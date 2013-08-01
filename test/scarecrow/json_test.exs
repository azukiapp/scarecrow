Code.require_file "../test_helper.exs", __DIR__

defmodule ScarecrowJSONTest do
  use ExUnit.Case
  alias Scarecrow.JSON

  test "normal encode support" do
    data = [user: "daniel"]
    result = JSON.decode(JSON.encode(data))

    assert data[:user], result["user"]
  end

  test "suport encode HashDict" do
    hash = HashDict.new(user: "foo", name: "Danie")
    objt = JSON.decode(JSON.encode(hash))

    assert hash[:user], objt["user"]
    assert hash[:name], objt["name"]
  end
end
