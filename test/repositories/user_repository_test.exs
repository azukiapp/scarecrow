Code.require_file "../test_helper.exs", __DIR__

defmodule UserRepositoryTest do
  use Athink
  use ExUnit.Case

  require UserRepository

  setup_all do
    {:ok, _} = UserRepository.data_store.remove_all_keys
    :ok
  end

  test "get user by username and password return error for invalid params" do
    assert {:error} == UserRepository.find_by_username_and_password(nil, nil)
    assert {:error} == UserRepository.find_by_username_and_password("foo", nil)
  end

  test "get user by username and password" do
    {:ok, user} = UserRepository.save(HashDict.new(username: "foo", password: "bar"))
    {:ok, user_finded} = UserRepository.find_by_username_and_password("foo", "bar")
    assert user.id == user_finded.id
    assert user.username == user_finded.username
  end
end
