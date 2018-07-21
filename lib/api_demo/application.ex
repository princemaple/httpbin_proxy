defmodule ApiDemo.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Plug.Adapters.Cowboy2.child_spec(
        scheme: :http,
        plug: ApiDemo.Router,
        options: [port: 80]
      )
    ]

    opts = [strategy: :one_for_one, name: ApiDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
