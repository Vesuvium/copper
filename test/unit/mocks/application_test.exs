defmodule CopperTest.Mocks.Application do
  use ExUnit.Case
  import Dummy

  alias Copper.Mocks.Application

  test "start/2" do
    children = [
      Copper.Repo,
      {Plug.Cowboy,
       scheme: :http, plug: Copper.Router, options: [port: 8000, compress: true]}
    ]

    dummy Supervisor, [{"start_link/2", :link}] do
      assert Application.start(1, 2) == :link

      assert called(
               Supervisor.start_link(children,
                 strategy: :one_for_one,
                 name: Copper.Supervisor
               )
             )
    end
  end
end
