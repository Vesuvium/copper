defmodule Copper.Utils do
  @items_per_page Application.get_env(:copper, :items_per_page, "20")

  def get_items(conn) do
    conn.query_params
    |> Map.get("items", @items_per_page)
    |> String.to_integer()
  end

  def get_page(conn) do
    conn.query_params
    |> Map.get("page", "1")
    |> String.to_integer()
  end
end
