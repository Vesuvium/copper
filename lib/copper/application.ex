defmodule Copper.Application do
  alias Copper.ModuleUtils, as: Utils

  defmacro __using__([]) do
    quote do
      use Application
      require Logger

      @port Application.get_env(
              unquote(Utils.atom_name(__CALLER__.module)),
              :port
            )

      def start(_type, _args) do
        repo = unquote(Utils.submodule(__CALLER__.module, "Repo"))
        router = unquote(Utils.submodule(__CALLER__.module, "Router"))
        supervisor = unquote(Utils.submodule(__CALLER__.module, "Supervisor"))

        children = [
          repo,
          {Plug.Cowboy,
           scheme: :http, plug: router, options: [port: @port, compress: true]}
        ]

        module = unquote(Utils.name(__CALLER__.module))
        Logger.info("#{module} started on port #{@port}")

        Supervisor.start_link(children, strategy: :one_for_one, name: supervisor)
      end
    end
  end
end
