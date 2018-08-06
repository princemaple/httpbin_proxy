defmodule HttpbinProxy.Bypass do
  @host "httpbin.org"

  import Plug.Conn

  def run(conn) do
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
