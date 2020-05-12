defmodule Copper.Siren do
  alias Copper.Siren
  alias Plug.Conn

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

end
