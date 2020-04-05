defmodule CopperTest.ModuleUtils do
  use ExUnit.Case
  import Dummy

  alias Copper.ModuleUtils

  test "name/1" do
    dummy Module, [{"split", [:split]}] do
      assert ModuleUtils.name("App.Module") == :split
      assert called(Module.split("App.Module"))
    end
  end

  test "atom_name/1" do
    dummy ModuleUtils, [{"name", "Name"}] do
      assert ModuleUtils.atom_name("App.Module") == :name
      assert called(ModuleUtils.name("App.Module"))
    end
  end

  test "submodule/2" do
    dummy Module, [{"concat", :concat}] do
      dummy ModuleUtils, [{"name", :name}] do
        assert ModuleUtils.submodule("App.Module", "Another") == :concat
        assert called(ModuleUtils.name("App.Module"))
        assert called(Module.concat([:name, "Another"]))
      end
    end
  end
end