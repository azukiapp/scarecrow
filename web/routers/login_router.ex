defmodule LoginRouter do
  use BaseRouter
  use Athink

  @unauthorized :jsx.encode([error: "Unauthorized user"])

  get "/" do
    conn = base_conn(conn)
    case User.get_by_user_and_password(conn.params[:username], conn.params[:password]) do
      {:ok, user} ->
        conn.resp(200, UserRepresenter.build(user))
      _ ->
        conn.resp(401, @unauthorized)
    end
  end
end
