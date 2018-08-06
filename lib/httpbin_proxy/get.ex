defmodule HttpbinProxy.Get do
  @behaviour Plug

  import Plug.Conn

  def init(_) do
    {:ok, []}
  end

  def call(conn, _) do
    response = HttpbinProxy.Bypass.run(conn)

    conn
    |> Map.put(
      :resp_headers,
      [{"x-implementation", "elixir"} | response.headers]
    )
    |> Map.put(:status, response.status_code)
    |> Map.put(:resp_body, response.body)
    |> Map.put(:state, :set)
    |> send_resp()
  end
end
