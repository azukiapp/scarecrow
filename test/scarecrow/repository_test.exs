Code.require_file "../test_helper.exs", __DIR__

defmodule Scarecrow.RepositoryTest do
  use ExUnit.Case

  defmodule DocumentTestRepository do
    use Scarecrow.Repository
  end

  @target DocumentTestRepository

  test "collection_name" do
    assert "document_tests" == @target.collection_name
  end
end
