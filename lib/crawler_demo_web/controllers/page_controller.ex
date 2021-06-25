defmodule CrawlerDemoWeb.PageController do
  use CrawlerDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
