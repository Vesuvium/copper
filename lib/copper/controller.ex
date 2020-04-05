defmodule Copper.Controller do
  alias Copper.ModuleUtils
  alias Ecto.{Changeset, Query, Schema}

  @callback new(host :: String.t(), params :: %{}) ::
              {:ok, Schema.t()} | {:error, Changeset.t()}

  @callback get(host :: String.t(), params :: %{}) ::
              {:ok, Schema.t()} | {:error, Changeset.t()}

  @callback by_id(host :: String.t(), id :: String.t()) ::
              {:ok, Schema.t()} | {:error, Query.CastError.t()}

  @callback edit(String.t(), String.t(), params :: %{}) ::
              {:ok, Schema.t()} | {:error, Changeset.t()}

  @callback delete(host :: String.t(), id :: String.t()) ::
              {integer(), nil | Query.CastError.t()}

  defmacro __using__([]) do
    quote do
      alias unquote(ModuleUtils.submodule(__CALLER__.module, "Repo"))

      alias unquote(
              __CALLER__.module
              |> Module.split()
              |> List.replace_at(1, "Schemas")
              |> Module.concat()
            )

      @behaviour Copper.Controller
    end
  end
end
