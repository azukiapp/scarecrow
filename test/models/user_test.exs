Code.require_file "../test_helper.exs", __DIR__

defmodule UserTest do
  use ExUnit.Case

  test "create a record for new user" do
    assert is_record(User.new, User)
    assert User.new.name == nil
    assert User.new(name: "Max").name == "Max"
  end

  test "check is new record" do
    user = User.new
    assert user.new_record?
  end
end
