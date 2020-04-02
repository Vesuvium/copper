defmodule Copper.Handler do
  alias Copper.Handler
  alias Plug.Conn

  def send_json(conn, status, payload) do
    conn
    |> Conn.put_resp_content_type("application/json")
    |> Conn.send_resp(status, Jason.encode!(payload))
  end

  def send_message(conn, status, message) do
    Handler.send_json(conn, status, %{:message => message})
  end

  def send_200(conn, payload), do: Handler.send_json(conn, 200, payload)

  def send_201(conn, payload), do: Handler.send_json(conn, 201, payload)

  def send_204(conn), do: Conn.send_resp(conn, 204, [])

  def send_400(conn, error), do: Handler.send_message(conn, 400, error)
  def send_400(conn), do: Handler.send_message(conn, 400, "Bad request")

  def send_403(conn) do
    Handler.send_message(conn, 403, "You're not allowed to perform this action")
  end

  def send_404(conn) do
    Handler.send_message(conn, 404, "The requested resource does not exist")
  end
end
