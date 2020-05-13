defmodule Copper.Siren do
  alias Copper.Siren
  alias Plug.Conn

  @items_per_page Application.get_env(:copper, :items_per_page)

  @doc """
  Merges two uris into one.
  """
  def merge_uris(lhs, rhs) do
    lhs
    |> URI.merge(rhs)
    |> URI.to_string()
  end

  @doc """
  Creates an updated uri to a new page.
  """
  def change_page(conn, new_page) do
    conn
    |> Conn.request_url()
    |> Siren.merge_uris("?" <> URI.encode_query(%{"page" => new_page}))
  end

  @doc """
  Adds a link to the next page, if it's not the last page.
  """
  def add_next(links, conn, count) do
    page = Map.get(conn.query_params, "page", "1") |> String.to_integer()

    items =
      Map.get(conn.query_params, "items", @items_per_page)
      |> String.to_integer()

    if page * items < count do
      [%{"rel" => "next", "href" => Siren.change_page(conn, page + 1)} | links]
    else
      links
    end
  end

  @doc """
  Adds a link to the previous page, if it's not the first page.
  """
  def add_prev(links, %{query_params: %{"page" => current_page}} = conn) do
    page = String.to_integer(current_page)

    if page == 1 do
      links
    else
      [%{"rel" => "prev", "href" => Siren.change_page(conn, page - 1)} | links]
    end
  end

  def add_prev(links, _conn), do: links

end
