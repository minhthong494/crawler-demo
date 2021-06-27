defmodule CrawlerDemoWeb.PageController do
  use CrawlerDemoWeb, :controller

  def index(conn, _params) do
    url = "https://shopee.vn/apple_flagship_store"
    data = Crawler.parse_item(url)
    render(conn, "index.html", data: data)
  end
end
