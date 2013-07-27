Code.require_file "../test_helper.exs", __DIR__

defmodule UserTest do
  use Athink
  use ExUnit.Case

  test "create a record for new user" do
    assert is_record(User.new, User)
    assert User.new.name == nil
    assert User.new(name: "Max").name == "Max"
  end

  test "get user by username and password return error for invalid params" do
    assert {:error} == User.get_by_user_and_password(nil, nil)
    assert {:error} == User.get_by_user_and_password("foo", nil)
  end

  test "get user by username and password" do
    user = HashDict.new(user: "foo", password: "bar")
    r(r.table("users").insert(user))

    {:ok, result} = User.get_by_user_and_password("foo", "bar")
    assert user[:user] == result["user"]
  end
end
