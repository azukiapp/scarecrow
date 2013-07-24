defmodule LoginRouter do
  use BaseRouter
  #import Lethink, only: [r: 0]

  @unauthorized :jsx.encode([error: "Unauthorized user"])

  get "/" do
    conn = base_conn(conn)
    case get_user(conn.params[:username], conn.params[:password]) do
      {:ok, user} ->
        conn.resp(200, UserPresenter.build(user))
      _ ->
        conn.resp(401, @unauthorized)
    end
  end

  defp get_user(user, password) when
    is_bitstring(user) and is_bitstring(password) and
    byte_size(user) > 0 and byte_size(password) > 0 do

      #case r.table("users").filter([user: user, password: password]).run(:azuki) do

      #end

      {:ok, [ name: user, user: user ] }
  end

  defp get_user(_, _), do: {:error}
end
