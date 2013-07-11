defmodule ApplicationRouter do
  use BaseRouter

  prepare do
    conn = conn.fetch([:cookies, :params, :headers])
    coneg_check(conn, :mimetypes.extension("json"))
  end

  finalize do
    add_json_headers(conn)
  end

  # It is common to break your Dynamo in many
  # routers forwarding the requests between them
  # forward "/posts", to: PostsRouter
  forward "/login", to: LoginRouter

  # TODO: Refactory conneg to process header: "Accept"
  defp coneg_check(conn, types) do
    content_type = Enum.at Enum.map(
      String.split(conn.req_headers["accept"] || "", ";"),
      String.strip &1
    ), 0

    unless Enum.any? types, &1 == content_type do
      halt_json!(conn, 406, "Not Acceptable")
    else
      conn
    end
  end

  def halt_json!(conn, status, message) do
    halt! add_json_headers(conn).resp(status, :jsx.encode([ error: message ]))
  end

  defp add_json_headers(conn) do
    conn
      .resp_content_type("application/json")
      .resp_charset "utf-8"
  end
end
