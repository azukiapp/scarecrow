Code.require_file "../test_helper.exs", __DIR__

defmodule UserTest do
  use ExUnit.Case
  alias Scarecrow.Utils

  require User

  test "create a record for new user" do
    assert is_record(User.new, User)
    assert User.new.name == nil
    assert User.new(name: "Max").name == "Max"
  end

  test "dynamic api_key create" do
    user = User.new
    assert String.length(Utils.api_key) == String.length(user.api_key)
  end
end
