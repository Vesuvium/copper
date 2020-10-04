defmodule CopperTest.Siren do
  use ExUnit.Case
  import Dummy

  alias Copper.Siren
  alias Copper.Siren.Links

  test "links/2" do
    dummy Links, [
      {"add_self/2", :self},
      {"add_prev/2", :prev},
      {"add_first/2", :first},
      {"add_next/3", :next},
      {"add_last/3", :last}
    ] do
      assert Siren.links(:conn, :count) == :last
      assert Links.add_self([], :conn)
      assert called(Links.add_prev(:self, :conn))
      assert called(Links.add_first(:prev, :conn))
      assert called(Links.add_next(:first, :conn, :count))
      assert called(Links.add_last(:next, :conn, :count))
    end
  end

  test "encode/3" do
    expected = %{entities: :payload, links: :links}

    dummy Siren, [{"links/2", :links}] do
      assert Siren.encode(:conn, :payload, :count) == expected
      assert called(Siren.links(:conn, :count))
    end
  end

  test "encode/2" do
    expected = %{properties: :payload, links: [:self]}

    dummy Links, [{"add_self/2", [:self]}] do
      assert Siren.encode(:conn, :payload) == expected
      assert called(Links.add_self([], :conn))
    end
  end
end
