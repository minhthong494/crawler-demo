defmodule Crawly.Fetchers.Splash do
  @moduledoc """
  Implements Crawly.Fetchers.Fetcher behavior for Splash Javascript rendering.

  Splash is a lightweight QT based Javascript rendering engine. See:
  https://splash.readthedocs.io/

  Splash exposes the render.html endpoint which renders incoming requests sent
  with ?url get parameter.

  This particular Splash fetcher converts all requests made by Crawly to Splash
  requests, and  cleans up the final responses, by removing the Splash parts
  from the response.

  It's possible to start splash server in any documented way. One of the options
  is to run it locally with a help of docker:
  docker run -it -p 8050:8050 scrapinghub/splash

  In this case you have to confugure the fetcher in the following way:
  `fetcher: {Crawly.Fetchers.Splash, [base_url: "http://localhost:8050/render.html"]},`
  """
  @behaviour Crawly.Fetchers.Fetcher

  require Logger

  @spec fetch(request, client_options) :: response
        when request: Crawly.Request.t(),
             client_options: [binary()],
             response: Crawly.Response.t()
  def fetch(request, client_options) do
    {base_url, other_options} =
      case Keyword.pop(client_options, :base_url, nil) do
        nil ->
          throw(
            "The base_url is not set. Splash fetcher can't be used! " <>
              "Please set :base_url in fetcher options to continue. " <>
              "For example: " <>
              "fetcher: {Crawly.Fetchers.Splash, [base_url: <url>]}"
          )

        {base_url, other_options} ->
          {base_url, other_options}
      end

    _query_parameters = URI.encode_query(Keyword.put(other_options, :url, request.url))

    # url =
    #   URI.merge(base_url, "?" <> query_parameters)
    #   |> URI.to_string()

    url = base_url

    body =
      Poison.encode!(%{
        url: request.url,
        wait: 3,
        lua_source: """
        function main(splash)
          local num_scrolls = 10
          local scroll_delay = 1

          local scroll_to = splash:jsfunc("window.scrollTo")
          local get_body_height = splash:jsfunc(
              "function() {return document.body.scrollHeight;}"
          )
          assert(splash:go(splash.args.url))
          splash:wait(splash.args.wait-scroll_delay)

          for i = 1, num_scrolls, 1 do
            scroll_to(0, get_body_height()*i/num_scrolls)
            splash:wait(scroll_delay/num_scrolls)
          end
          return splash:html()
        end
        """
        # js_source:
        #   "i= 0; setInterval( () => {if (i<splash:jsfunc(\"document.body.scrollHeight\")) {splash:jsfunc(\"window.scrollTo(0, i)\"}; i+=100; console.log(i);} , 50)"
      })

    headers = [{:"Content-Type", "application/json"}]
    options = [{:recv_timeout, 10000}]

    case HTTPoison.post(url, body, headers, options) do
      {:ok, response} ->
        new_request = %HTTPoison.Request{response.request | url: request.url}

        new_response = %HTTPoison.Response{
          response
          | request: new_request,
            request_url: request.url
        }

        {:ok, new_response}

      error ->
        error
    end
  end
end
