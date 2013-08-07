defmodule Scarecrow.Repository do
  defmacro __using__(_opts) do
    quote do
      @collection_name unquote(__MODULE__).collection_name(__MODULE__)

      def collection_name do
        @collection_name
      end
    end
  end

  @name_match %r/(.*)Repository$/
  def collection_name(module) do
    module = List.last(Module.split(module))
    Inflector.tableize(Regex.replace(@name_match, "#{module}", "\\1"))
  end
end
