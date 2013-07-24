defmodule LoginRouter do
  use BaseRouter
  use Athink

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

      where = HashDict.new(user: user, password: password)
      case r(r.table("users").filter(where)) do
        {:ok, [user]} when is_record(user, HashDict) ->
          {:ok, user.to_list}
        _ ->
          {:error, "user not found"}
      end
  end

  defp get_user(_, _), do: {:error}
end
