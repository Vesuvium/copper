defmodule Copper.Siren do
  alias Plug.Conn

  @doc """
  Merges two uris into one.
  """
  def merge_uris(lhs, rhs) do
    lhs
    |> URI.merge(rhs)
    |> URI.to_string()
  end
end
