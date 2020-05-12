defmodule CopperTest.Siren do
  use ExUnit.Case
  import Dummy

  alias Copper.Siren
  alias Plug.Conn

  test "merge_uris/2" do
    dummy URI, [{"merge/2", :merge}, {"to_string", :uri}] do
      assert Siren.merge_uris("lhs", "rhs") == :uri
      assert called(URI.merge("lhs", "rhs"))
      assert called(URI.to_string(:merge))
    end
  end

  test "change_page/2" do
    dummy Conn, [{"request_url", "url"}] do
      dummy URI, [{"encode_query", "query"}] do
        dummy Siren, [{"merge_uris/2", :merge}] do
          assert Siren.change_page(:conn, 2) == :merge
          assert called(Conn.request_url(:conn))
          assert called(URI.encode_query(%{"page" => 2}))
          assert called(Siren.merge_uris("url", "?query"))
        end
      end
    end
  end
end
