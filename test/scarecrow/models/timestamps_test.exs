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
    assert doc.created_at == doc.updated_at
  end

  test "support to force a timestamps values" do
    date = Date.shift(Date.now, 1, :days)
    doc  = DocumentTest.new(created_at: date, updated_at: date)
    assert date == doc.created_at
    assert date == doc.updated_at
  end

  test "inject touch method" do
    date = Date.shift(Date.now, 1, :sec)
    doc  = DocumentTest.new(created_at: date, updated_at: date)
    doc  = doc.touch
    assert 1 >= Date.diff(doc.created_at, doc.updated_at, :sec)
  end
end

