Code.require_file "../test_helper.exs", __DIR__

defmodule ScarecrowUtilsTest do
  use ExUnit.Case
  alias Scarecrow.Utils

  test "valid api_key generate" do
    api_key = Utils.api_key
    assert is_bitstring(api_key)
    assert :uuid.is_valid('#{api_key}')
  end
end
