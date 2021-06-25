defmodule Crawler do
  def parse_item(url) do
    response = Crawly.fetch(url)
    {:ok, document} = Floki.parse_document(response.body)

    list = document |> Floki.find(".shop-search-result-view ._35LNwy>.fBhek2")

    Enum.map(list, fn block ->
      {_, _, children} = block
      name = Floki.find(children, "._1ObP5d .yQmmFK._1POlWt._36CEnF") |> Floki.text()

      price =
        Floki.find(children, "._1ObP5d .WTFwws._1lK1eK._5W0f35 ._29R_un") |> Floki.text(sep: "-")

      IO.inspect(price)
      quan = Floki.find(children, "._1ObP5d .go5yPW") |> Floki.text()

      img_url = Floki.find(children, "._25_r8I>img") |> Floki.attribute("src") |> Floki.text()

      %{
        "name" => name,
        "img_url" => img_url,
        "price" => price,
        "quan" => quan
      }
    end)
  end
end
