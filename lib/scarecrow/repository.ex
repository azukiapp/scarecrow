defmodule Scarecrow.Repository do
  defmacro __using__(opts) do
    quote do
      alias Scarecrow.Repository.Rethinkdb, as: RethinkdbBackend

      @collection_name unquote(__MODULE__).collection_name(__MODULE__)
      @record_module unquote(opts[:record]) || unquote(__MODULE__).record_module(__MODULE__)
      @data_store RethinkdbBackend.new(__MODULE__)

      def collection_name do
        @collection_name
      end

      def record do
        @record_module
      end

      def save(data) do
        data_store.save(data)
      end

      def find_by_id(id) do
        data_store.find_by_id(id)
      end

      def find_by_attributes(attributes) do
        data_store.find_by_attributes(attributes)
      end

      def data_store do
        @data_store
      end
    end
  end

  @name_match %r/(.*)Repository$/
  def collection_name(module) do
    module = List.last(Module.split(module))
    Inflector.tableize(Regex.replace(@name_match, "#{module}", "\\1"))
  end

  def record_module(module) do
    module = List.last(Module.split(module))
    :'#{Regex.replace(@name_match, "#{module}", "\\1")}'
  end
end
