Code.require_file "../test_helper.exs", __DIR__

defmodule Scarecrow.RepositoryTest do
  use ExUnit.Case

  defrecord DocumentTest, title: nil, author: nil, id: nil

  defmodule DocumentTestRepository do
    use Scarecrow.Repository, record: DocumentTest
  end

  alias DocumentTestRepository, as: Target

  setup_all do
    {:ok, _} = Target.data_store.remove_all_keys
    :ok
  end

  test "collection_name" do
    assert "document_tests" == Target.collection_name
  end

  test "module" do
    assert DocumentTest == Target.record
  end

  test "create collection if not exist" do
    {:module, module, _, _} = defmodule CollectionCreateTestRepository do
      use Scarecrow.Repository, record: DocumentTest
    end

    module.data_store.collection_drop
    {:error, _, :RUNTIME_ERROR, _} = module.data_store.collection_info

    {:ok, _}    = module.save(HashDict.new())
    {:ok, info} = module.data_store.collection_info
    assert is_record(info, HashDict)
  end

  test "save dict" do
    dict = HashDict.new(title: "Any")
    {:ok, doc} = Target.save(dict)

    assert dict[:title] == doc.title
    assert nil != doc.id
  end

  test "update a old data" do
    {:ok, doc} = Target.save(HashDict.new(title: "Any"))
    id  = doc.id

    doc = doc.title "Other"
    {:ok, doc} = Target.save(doc)

    assert id == doc.id
    assert "Other" == doc.title
  end

  test "support to persist a record" do
    {:ok, doc} = Target.save(DocumentTest.new(title: "Title"))
    assert is_record(doc, DocumentTest)
    assert nil != doc.id
    assert "Title" == doc.title
  end

  # Finds
  test "find a document by id" do
    {:ok, doc_old} = Target.save(HashDict.new(title: "Foo Bar"))
    {:ok, doc_new} = Target.find_by_id(doc_old.id)

    assert doc_old.id == doc_new.id
    assert doc_old.title == doc_new.title
  end

  test "find by attributes" do
    attributes = HashDict.new(title: "title", author: "author")
    {:ok, doc} = Target.save(attributes)
    {:ok, doc_finded} = Target.find_by_attributes(attributes)

    assert doc.id == doc_finded.id
    assert doc.title == doc_finded.title
  end
end
