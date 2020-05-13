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

  test "add_next/3" do
    conn = %{query_params: %{"page" => "2"}}
    expected = [%{"rel" => "next", "href" => :page}]

    dummy Siren, [{"change_page/2", :page}] do
      assert Siren.add_next([], conn, 100) == expected
      assert called(Siren.change_page(conn, 3))
    end
  end

  test "add_next/3 without a given page" do
    conn = %{query_params: %{}}

    dummy Siren, [{"change_page/2", :page}] do
      Siren.add_next([], conn, 100)
      assert called(Siren.change_page(conn, 2))
    end
  end

  test "add_next/3 with items * page > count" do
    conn = %{query_params: %{"items" => "200"}}

    assert Siren.add_next([], conn, 100) == []
  end

  test "add_next/3 with items * page < count" do
    conn = %{query_params: %{"items" => "1"}}
    expected = [%{"rel" => "next", "href" => :page}]

    dummy Siren, [{"change_page/2", :page}] do
      assert Siren.add_next([], conn, 100) == expected
    end
  end

  test "add_next/3 on last page" do
    assert Siren.add_next([], %{query_params: %{"page" => "5"}}, 100) == []
  end

  test "add_prev/2" do
    conn = %{query_params: %{"page" => "2"}}

    dummy Siren, [{"change_page/2", :page}] do
      assert Siren.add_prev([], conn) == [%{"rel" => "prev", "href" => :page}]
      assert called(Siren.change_page(conn, 1))
    end
  end

  test "add_prev/2 on the first page" do
    assert Siren.add_prev([], %{query_params: %{"page" => "1"}}) == []
  end

  test "add_prev/2 without a page" do
    assert Siren.add_prev([], %{query_params: %{}}) == []
  end
end
