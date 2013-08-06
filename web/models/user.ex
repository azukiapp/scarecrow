defmodule User do
  use Scarecrow.Models.Document
  #use Scarecrow.Models.Timestamps
  use Scarecrow.Models.Rethinkdb

  field :name
  field :user
  field :email
  field :password
  field :verified, default: false
  field :verified_at, default: nil

  field :api_key, default: fn self(api_key: api_key) ->
    api_key || Scarecrow.Utils.api_key
  end

  def get_by_user_and_password(user, password) when
    is_bitstring(user) and is_bitstring(password) and
    byte_size(user) > 0 and byte_size(password) > 0 do

      where = HashDict.new(user: user, password: password)
      case r(r.table("users").filter(where)) do
        {:ok, [user]} when is_record(user, HashDict) ->
          {:ok, user.to_list}
        {:ok, users} ->
          {:error, "multiple users", users}
        _ ->
          {:error, "user not found"}
      end
  end

  def get_by_user_and_password(_, _), do: {:error}
end
