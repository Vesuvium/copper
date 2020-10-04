defmodule Copper.Siren do
  alias Copper.Siren
  alias Copper.Siren.Links

  def links(conn, count) do
    []
    |> Links.add_self(conn)
    |> Links.add_prev(conn)
    |> Links.add_first(conn)
    |> Links.add_next(conn, count)
    |> Links.add_last(conn, count)
  end

  @doc """
  Encodes a payload to Siren.
  """
  def encode(conn, payload, count) do
    %{
      entities: payload,
      links: Siren.links(conn, count)
    }
  end

  def encode(conn, payload) do
    %{properties: payload, links: Links.add_self([], conn)}
  end
end
