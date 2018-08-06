defmodule HttpbinProxy.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/get", to: HttpbinProxy.Get

  post "/post" do
    my_own_post_data = %{a: 1, b: 2, x: "x"}

    HttpbinProxy.Lab.compare(conn, my_own_post_data)

    conn
    |> put_resp_header("x-implementation", "elixir")
    |> put_resp_header("content-type", "application/json")
    |> send_resp(:ok, Jason.encode!(my_own_post_data))
  end

  get "/lab" do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(:ok, Jason.encode!(HttpbinProxy.Lab.fetch_all()))
  end

  get "/cachable/*path" do
    resp =
      conn
      |> Map.put(:request_path, "/" <> Path.join(path))
      |> HttpbinProxy.Cache.fetch()

    conn
    |> put_resp_header("x-implementation", "elixir")
    |> put_resp_header("content-type", "application/json")
    |> send_resp(:ok, resp.body)
  end

  match "*unknwon" do
    response = HttpbinProxy.Bypass.run(conn)

    conn
    |> Map.put(:resp_headers, response.headers)
    |> Map.put(:status, response.status_code)
    |> Map.put(:resp_body, response.body)
    |> Map.put(:state, :set)
    |> send_resp()
  end
end
