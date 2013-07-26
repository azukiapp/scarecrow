defmodule User do
  use Athink
  use Scarecrow.Models.Document
  use Scarecrow.Models.Timestamps

  field :name
  field :email
  field :verified, default: false
  field :verified_at, default: nil

  def name(record) do
    super record
  end

  def name(value, record) do
    super value, record
  end

  def new_record?(record) do
    !record._id
  end

  def get_by_user_and_password(user, password) when
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

  def get_by_user_and_password(_, _), do: {:error}
end
