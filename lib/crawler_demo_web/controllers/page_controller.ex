defmodule CrawlerDemoWeb.PageController do
  use CrawlerDemoWeb, :controller
  @cache_data_key 13
  @cache_duration 3600 * 24

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    url = "https://shopee.vn/apple_flagship_store"

    data =
      case SimpleCache.get(@cache_data_key) do
        {:ok, data} ->
          IO.puts("HIT")
          data

        {:error, _} ->
          IO.puts("MISS")
          data = Crawler.parse_item(url)
          SimpleCache.set(@cache_data_key, data, @cache_duration)
          data
      end

    render(conn, "index.html", data: data)
  end
end
