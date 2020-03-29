defmodule Copper.Router do
  defmacro expand_plugs(plugs) do
    quote do
      if unquote(plugs) == nil do
        plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
        plug(:match)
        plug(:dispatch)
      else
        for plug_name <- unquote(plugs) do
          plug(plug_name)
        end
      end
    end
  end

  defmacro resource(name) do
    quote bind_quoted: [name: name] do
      def call(%Plug.Conn{method: "GET", path_info: [name]} = conn, _opts) do
        send_resp(conn, 200, name)
      end
    end
  end

  defmacro __using__(opts \\ []) do
    quote do
      import Copper.Handler
      import Copper.Router
      use Plug.Router

      expand_plugs(unquote(opts[:plugs]))
    end
  end
end
