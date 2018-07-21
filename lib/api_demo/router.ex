defmodule HttpbinProxy.Router do
  @host "httpbin.org"

  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  match "*unknwon" do
    {:ok, body, conn} = read_body(conn)

    conn =
      conn
      |> put_req_header("host", @host)

    target =
      %URI{
        scheme: "https",
        host: @host,
        path: conn.request_path,
        query: conn.query_string
      }

    response =
      HTTPoison.request!(
        conn.method |> String.downcase() |> String.to_existing_atom(),
        URI.to_string(target),
        body,
        conn.req_headers
      )

    conn
    |> Map.put(:resp_headers, response.headers)
    |> Map.put(:status, response.status_code)
    |> Map.put(:resp_body, response.body)
    |> Map.put(:state, :set)
    |> send_resp()
  end
end
