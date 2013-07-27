Code.require_file "../../test_helper.exs", __DIR__

defmodule ScarecrowModelsTimestampsTest do
  use ExUnit.Case
  alias Scarecrow.Models

  defmodule DocumentTest do
    use Models.Document
    use Models.Timestamps
  end

  test "document record have a timestamps fields" do
    assert is_record(DocumentTest.new, DocumentTest)
    assert ListDict.has_key?(DocumentTest.__record__(:fields), :created_at)
    assert ListDict.has_key?(DocumentTest.__record__(:fields), :updated_at)
  end

  test "set date after new object" do
    doc = DocumentTest.new
    assert is_record(doc.created_at, Date.Gregorian)
    assert is_record(doc.updated_at, Date.Gregorian)
  end
end
