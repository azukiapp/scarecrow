defmodule ApplicationRouter do
  use BaseRouter

  prepare do
    conn = conn.fetch([:params, :headers])
    coneg_check(conn, :mimetypes.extension("json"))
  end

  finalize do
    base_conn(conn)
  end

  # It is common to break your Dynamo in many
  # routers forwarding the requests between them
  # forward "/posts", to: PostsRouter
  forward "/login", to: LoginRouter

  @root :jsx.encode([
    _links: [
      [authentication: [ href: "/authetication" ]],
      [apps: [ href: "/apps" ]]
    ],
    version: "v0.0.1"
  ])

  get "/" do
    base_conn(conn)
      .resp(200,  @root)
  end

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
    halt! base_conn(conn).resp(status, :jsx.encode([ error: message ]))
  end
end
