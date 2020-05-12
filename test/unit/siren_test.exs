defmodule CopperTest.Siren do
  use ExUnit.Case
  import Dummy

  alias Copper.Siren

  test "merge_uris/2" do
    dummy URI, [{"merge/2", :merge}, {"to_string", :uri}] do
      assert Siren.merge_uris("lhs", "rhs") == :uri
      assert called(URI.merge("lhs", "rhs"))
      assert called(URI.to_string(:merge))
    end
  end
end
