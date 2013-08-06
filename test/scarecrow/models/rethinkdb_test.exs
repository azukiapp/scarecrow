Code.require_file "../../test_helper.exs", __DIR__

defmodule Scarecrow.Models.RethinkdbTest do
  use Athink
  use ExUnit.Case
  alias Scarecrow.Models

  defmodule DocumentTest do
    use Models.Document
    use Models.Rethinkdb

    field :title
    field :author
  end

  setup_all do
    table_name = DocumentTest.__document__(:table_name)
    r(r.table_drop(table_name))
    {:ok, _} = r(r.table_create(table_name))
    :ok
  end

  test "have a id field" do
    assert Keyword.has_key?(DocumentTest.__record__(:fields), :id)
  end

  test "adding method to check is new or persisted document" do
    assert DocumentTest.new.new_record?
    refute DocumentTest.new(id: "key").new_record?
    refute DocumentTest.new.persisted?
    assert DocumentTest.new(id: "key").persisted?
  end

  test "default table name" do
    assert Inflector.tableize("DocumentTest") == DocumentTest.__document__(:table_name)
  end

  test "customize table name" do
    defmodule Doc do
      use Models.Document
      use Models.Rethinkdb

      store_in table: "documents"
    end

    assert "documents" == Doc.__document__(:table_name)
  end

  test "create table if not exist" do
    {:module, module, _, _} = defmodule DocTableCreateTest do
      use Models.Document
      use Models.Rethinkdb
    end

    table_name = module.__document__(:table_name)
    r(r.table_drop(table_name))
    {:error, _, :RUNTIME_ERROR, _} = r(r.table(table_name).info)

    {:ok, _} = module.new.save
    {:ok, info} = r(r.table(table_name).info)
    assert is_record(info, HashDict)
  end

  # Persistence
  test "support save a new document and auto get by id" do
    doc   = DocumentTest.new(title: "Programming Erlang")
    {:ok, doc_p} = doc.save

    assert doc.title == doc_p.title
    assert doc_p.persisted?
  end

  test "support to save a change document" do
    {:ok, doc} = DocumentTest.new(title: "Foo Bar").save
    assert doc.persisted?
    {:ok, _  } = doc.title("Bar Foo").save

    {:ok, doc_n} = DocumentTest.get(doc.id)
    assert "Bar Foo" == doc_n.title
  end

  test "support to update partial object" do
    {:ok, doc} = DocumentTest.new(title: "Foo bar").save
    assert doc.persisted?
    {:ok, doc} = doc.update(title: "Bar foo")
    assert "Bar foo" == doc.title
    {:ok, doc_n} = DocumentTest.get(doc.id)
    assert doc.title == doc_n.title
  end

  # Finds
  test "get a document by id" do
    doc = HashDict.new(title: "Foo Bar")
    {:ok, result} = r(r.table(DocumentTest.__document__(:table_name)).insert(doc))
    assert 1.0 == result["inserted"]

    [id | _]   = result["generated_keys"]
    {:ok, doc} = DocumentTest.get(id)
    assert "Foo Bar" = doc.title
  end
end
