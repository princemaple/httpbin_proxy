defmodule HttpbinProxy.Lab do
  use GenServer

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def compare(conn, resp) do
    GenServer.cast(__MODULE__, {:compare, conn, resp})
  end

  def fetch_all do
    GenServer.call(__MODULE__, :fetch_all)
  end

  def init(_) do
    {:ok, :ets.new(:lab, [:duplicate_bag, :public, :named_table])}
  end

  def handle_cast({:compare, conn, body}, ref) do
    resp = HttpbinProxy.Bypass.run(conn)
    pair = {body, resp.body}
    :ets.insert(ref, {conn.request_path, pair})
    Logger.debug(inspect pair)
    {:noreply, ref}
  end

  def handle_call(:fetch_all, _from, ref) do
    {:reply, :ets.match(ref, {:"$1", {:"$2", :"$3"}}), ref}
  end
end
