defmodule Copper.Siren do
  alias Copper.Siren
  alias Copper.Utils
  alias Plug.Conn

  @doc """
  Merges two uris into one.
  """
  def merge_uris(lhs, rhs) do
    lhs
    |> URI.merge(rhs)
    |> URI.to_string()
  end

  def parse_uri(conn), do: conn |> Conn.request_url() |> URI.parse()

  @doc """
  Creates an updated uri to a new page.
  """
  def change_page(conn, new_page) do
    url = Siren.parse_uri(conn)

    query =
      url
      |> Map.get(:query)
      |> URI.decode_query()
      |> Map.put("page", new_page)
      |> URI.encode_query()

    Map.put(url, :query, query)
  end

  @doc """
  Adds a link to the next page, if it's not the last page.
  """
  def add_next(links, conn, count) do
    page = Utils.get_page(conn)
    items = Utils.get_items(conn)

    if page * items < count do
      [%{"rel" => "next", "href" => Siren.change_page(conn, page + 1)} | links]
    else
      links
    end
  end

  @doc """
  Adds a link to the last page
  """
  def add_last(links, conn, count) do
    last_page = ceil(count / Utils.get_items(conn))
    [%{"rel" => "last", "href" => Siren.change_page(conn, last_page)} | links]
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

  def add_self(links, conn) do
    [%{"rel" => "self", "href" => Conn.request_url(conn)} | links]
  end

  def links(conn, count) do
    []
    |> Siren.add_self(conn)
    |> Siren.add_prev(conn)
    |> Siren.add_next(conn, count)
    |> Siren.add_last(conn, count)
  end

  @doc """
  Encodes a payload to Siren.
  """
  def encode(conn, payload, count) do
    %{
      "entities" => payload,
      "links" => Siren.links(conn, count)
    }
  end

  def encode(conn, payload) do
    %{"properties" => payload, "links" => Siren.add_self([], conn)}
  end
end
