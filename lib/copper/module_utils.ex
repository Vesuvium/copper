defmodule Copper.ModuleUtils do
  alias Copper.ModuleUtils

  def name(module), do: module |> Module.split() |> List.first()

  def atom_name(module) do
    module |> ModuleUtils.name() |> String.downcase() |> String.to_atom()
  end

  def submodule(module, submodule) do
    Module.concat([ModuleUtils.name(module), submodule])
  end
end
