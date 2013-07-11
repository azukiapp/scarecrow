Code.require_file "../test_helper.exs", __DIR__

defmodule UserPresenterTest do
  use ExUnit.Case

  test "return a json representation with property" do
    user   = [ user: "my_user", name: "Jonh" ]
    result = :jsx.decode(UserPresenter.build(:json, user))
    assert user[:user] === result["user"]
    assert user[:name] === result["name"]
  end

  test "not return property not is map" do
    user   = [ user: "my_user", name: "Jonh", other: "foo" ]
    result = :jsx.decode(UserPresenter.build(:json, user))
    assert user[:user] === result["user"]
    refute Dict.has_key?(result, "other")
  end

  test "return a self link" do
    user   = [ user: "my_user", name: "Jonh", other: "foo" ]
    result = :jsx.decode(UserPresenter.build(:json, user))

    assert Dict.has_key?(result, "_links")
    assert Dict.has_key?(result["_links"], "self")
    assert Dict.equal?(result["_links"]["self"], [ {"href", "/user/my_user"} ])
  end
end
