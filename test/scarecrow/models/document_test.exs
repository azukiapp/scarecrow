Code.require_file "../../test_helper.exs", __DIR__

defmodule ScarecrowModelsDocumentTest do
  use ExUnit.Case
  alias Scarecrow.Models

  import ExUnit.CaptureIO

  defmodule DocumentTest do
    use Models.Document, self: :doc

    field :title

    # Override support
    field :author, default: "Joel"
    field :author, default: "Daniel"

    field :about, default: fn doc(title: title, author: author, about: about) ->
      about || "#{title} <#{author}>"
    end

    defoverridable [title: 2]
    def title(value, doc(title: old) = record) do
      if old == "First title", do: IO.write(old)
      doc(record, title: value)
    end

    defoverridable [author: 2]
    def author(value, doc(author: old) = record) do
      if old == "Max", do: IO.write(old)
      super value, record
    end
  end

  test "check is a record" do
    doc = DocumentTest.new
    assert is_record(doc, DocumentTest)
  end

  test "fields as fields of the record" do
    fields = DocumentTest.__record__ :fields
    assert ListDict.has_key?(fields, :title)
    assert ListDict.has_key?(fields, :author)
  end

  test "fields have a default value" do
    assert "Daniel", DocumentTest.__record__(:fields)[:author]
  end

  test "override using macro record" do
    doc = DocumentTest.new()
    doc = doc.title "First title"
    assert "First title" == doc.title

    assert "First title" == capture_io(fn ->
      doc.title "Second title"
    end)
  end

  test "override using super call" do
    doc = DocumentTest.new.author "Max"
    assert "Max", doc.author

    assert "Max" == capture_io(fn ->
      doc.author "Bill"
    end)
  end

  test "supports functions as a default value" do
    doc = DocumentTest.new(title: "My book")
    assert "#{doc.title} <#{doc.author}>" == doc.about
    doc = DocumentTest.new(about: "Your book")
    assert "Your book" == doc.about
  end
end
