defmodule HttpbinProxy.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      HttpbinProxy.Cache,
      HttpbinProxy.Lab,
      Plug.Adapters.Cowboy2.child_spec(
        scheme: :http,
        plug: HttpbinProxy.Router,
        options: [port: 80]
      )
    ]

    opts = [strategy: :one_for_one, name: HttpbinProxy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
