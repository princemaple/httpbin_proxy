defmodule HttpbinProxy.LabWorker do
  use GenServer, restart: :temporary

  require Logger

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  def start(conn, body) do
    DynamicSupervisor.start_child(
      LabWorkerSupervisor,
      {__MODULE__, {conn, body}}
    )
  end

  def init({conn, body}) do
    send(self(), :work)
    {:ok, {conn, body}}
  end

  def handle_info(:work, {conn, body}) do
    %{body: upstream_body} = HttpbinProxy.Bypass.run(conn)
    HttpbinProxy.Lab.compare(conn, body, upstream_body)
    {:stop, :normal, {conn, body, upstream_body}}
  end
end
