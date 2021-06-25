defmodule CrawlerDemoWeb.PageView do
  use CrawlerDemoWeb, :view

  def crawl_data() do
    url = "https://shopee.vn/apple_flagship_store"
    Crawler.parse_item(url)
  end
end
