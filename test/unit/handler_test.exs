defmodule CopperTest.Handler do
  use ExUnit.Case

  alias Copper.Handler
  alias Plug.Conn

  import Dummy

  test "send_json/3" do
    dummy Conn, [
      {"send_resp/3", :resp},
      {"put_resp_content_type/2", :content_type}
    ] do
      dummy Jason, [{"encode!", :json}] do
        assert Handler.send_json(:conn, 200, %{}) == :resp
        assert called(Conn.put_resp_content_type(:conn, "application/json"))
        assert called(Jason.encode!(%{}))
        assert called(Conn.send_resp(:content_type, 200, :json))
      end
    end
  end

  test "send_message/3" do
    dummy Handler, [{"send_json/3", :json}] do
      assert Handler.send_message(:conn, 200, "hello") == :json
      assert called(Handler.send_json(:conn, 200, %{:message => "hello"}))
    end
  end

  test "send_200" do
    dummy Handler, [{"send_json/3", :json}] do
      assert Handler.send_200(:conn, "hello") == :json
      assert called(Handler.send_json(:conn, 200, "hello"))
    end
  end
  test "send_400/2" do
    dummy Handler, [{"send_message/3", :resp}] do
      assert Handler.send_400(:conn, :error) == :resp
      assert called(Handler.send_message(:conn, 400, :error))
    end
  end

  test "send_400/1" do
    dummy Handler, [{"send_message/3", :resp}] do
      assert Handler.send_400(:conn) == :resp
      assert called(Handler.send_message(:conn, 400, "Bad request"))
    end
  end

  test "send_403/1" do
    message = "You're not allowed to perform this action"

    dummy Handler, [{"send_message/3", :resp}] do
      assert Handler.send_403(:conn) == :resp
      assert called(Handler.send_message(:conn, 403, message))
    end
  end

  test "send_404/1" do
    message = "The requested resource does not exist"

    dummy Handler, [{"send_message/3", :resp}] do
      assert Handler.send_404(:conn) == :resp
      assert called(Handler.send_message(:conn, 404, message))
    end
  end
end
