defmodule UserRepository do
  use Scarecrow.Repository, record: User

  def find_by_username_and_password(username, password) when
    is_bitstring(username) and is_bitstring(password) and
    byte_size(username) > 0 and byte_size(password) > 0 do
      find_by_attributes(HashDict.new(username: username, password: password))
  end

  def find_by_username_and_password(_, _), do: {:error}
end
