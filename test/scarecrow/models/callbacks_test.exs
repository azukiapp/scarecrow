Code.require_file "../../test_helper.exs", __DIR__

defmodule Scarecrow.Models.CallbacksTest do
  use ExUnit.Case
  alias Scarecrow.Models

  defmodule CallbacksTest do
    use Models.Callbacks

    set_callback [before_test: 1, before_test: 2], :before, :before_meth
    #set_callback [after_test: 1] , :after , :after_meth
    #set_callback [around_test: 1], :around, :around_meth

    # Methos to capture callbacks
    def before_test(v1) do
      v1 * 2
    end

    def before_test(v1, v2) do
      v1 + v2
    end

    # Callbacks
    def before_meth(v1) do
      v1 * 2
    end

    def before_meth(v1, v2) do
      [v1 + 1, v2 + 1]
    end
  end

  test "support before call back" do
    assert 8 == CallbacksTest.before_test(2)
    assert 4 == CallbacksTest.before_test(1, 1)
  end
end
