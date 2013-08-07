Code.require_file "../test_helper.exs", __DIR__

defmodule Scarecrow.RepositoryTest do
  use ExUnit.Case

  defmodule DocumentTestRepository do
    use Scarecrow.Repository
  end

  @target DocumentTestRepository

  setup_all do
    {:ok, _} = @target.data_store.remove_all_keys
    :ok
  end

  test "collection_name" do
    assert "document_tests" == @target.collection_name
  end

  test "create collection if not exist" do
    {:module, module, _, _} = defmodule CollectionCreateTestRepository do
      use Scarecrow.Repository
    end

    module.data_store.collection_drop
    {:error, _, :RUNTIME_ERROR, _} = module.data_store.collection_info

    {:ok, _}    = module.save(HashDict.new())
    {:ok, info} = module.data_store.collection_info
    assert is_record(info, HashDict)
  end

  test "save a object" do
    doc = HashDict.new(title: "Any")
    {:ok, doc} = @target.save(doc)
    assert "Any" == doc[:title]
    assert nil   != doc[:id]
  end

  test "replace a old object" do
    doc = HashDict.new(title: "Any")
    {:ok, doc} = @target.save(doc)
    id  = doc[:id]

    doc = Dict.put(doc, :title, "Other")
    {:ok, doc} = @target.save(doc)

    assert id == doc[:id]
    assert "Other" == doc[:title]
  end
end
