Code.require_file "../test_helper.exs", __DIR__

defmodule UserPresenterTest do
  use ExUnit.Case
  use Athink

  test "user presenter" do
    user = [user: "ringo", name: "Ringo Starr", password: "foobar"]

    r(r.table("users").delete)

    {:ok, _} = r(r.table("users").insert(HashDict.new(user)))
    {:ok, [user]} = r(r.table("users").filter(HashDict.new(user: "ringo")))

    IO.inspect(user)
    assert "ringo", user["user"]
  end
end
