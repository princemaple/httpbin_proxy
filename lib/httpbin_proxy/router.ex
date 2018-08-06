defmodule HttpbinProxy.Router do
  @host "httpbin.org"

  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/get" do
    response = bypass(conn)

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

  match "*unknwon" do
    response = bypass(conn)

    conn
    |> Map.put(:resp_headers, response.headers)
    |> Map.put(:status, response.status_code)
    |> Map.put(:resp_body, response.body)
    |> Map.put(:state, :set)
    |> send_resp()
  end

  defp bypass(conn) do
    {:ok, body, conn} = read_body(conn)

    conn =
      conn
      |> IO.inspect()
      |> put_req_header("host", @host)
      |> put_req_header(
        "x-forward-for",
        conn.remote_ip |> Tuple.to_list |> Enum.join(".")
      )

    target =
      %URI{
        scheme: "https",
        host: @host,
        path: conn.request_path,
        query: conn.query_string
      }

    HTTPoison.request!(
      conn.method |> String.downcase() |> String.to_existing_atom(),
      URI.to_string(target),
      body,
      conn.req_headers
    )
  end
end
