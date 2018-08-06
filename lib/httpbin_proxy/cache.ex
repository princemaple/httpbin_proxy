defmodule HttpbinProxy.Cache do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def fetch(conn) do
    GenServer.call(__MODULE__, {:fetch, conn})
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:fetch, conn}, _from, cache) do
    {cache, resp} =
      case Map.get(cache, conn.request_path) do
        nil ->
          resp = HttpbinProxy.Bypass.run(conn)
          {Map.put(cache, conn.request_path, resp), resp}
        resp ->
          {cache, resp}
      end

    {:reply, resp, cache}
  end
end
