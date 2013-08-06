Code.require_file "test_helper.exs", __DIR__

defmodule InflectorTest do
  use ExUnit.Case
  import Inflector

  test "tableize" do
    assert "raw_scaled_scorers" == tableize("RawScaledScorer")
    assert "egg_and_hams" == tableize("egg_and_ham")
    assert "fancy_categories" == tableize("fancyCategory")
  end
end
