defmodule Scarecrow.Models.Rethinkdb do

  defrecord Result,
    deleted: 0, errors: 0, generated_keys: [], inserted: 0, replaced: 0, skipped: 0, unchanged: 0

  defmacro __using__(_opts) do
    quote do
      use Athink
      import :macros, unquote(__MODULE__)

      field :id, default: nil

      @table_name unquote(__MODULE__).table_name(__MODULE__)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro store_in(opts) do
    quote bind_quoted: binding do
      Enum.each(opts, fn {key, value} ->
        case key do
          :table -> @table_name "#{value}"
        end
      end)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def new_record?(record) do
        !record.id
      end

      def persisted?(record) do
        !new_record?(record)
      end

      def save(record) do
        insert(record)
      end

      def get(key) do
        find_query(table.get(key))
      end

      def insert(record) do
        doc = HashDict.new(Keyword.delete(record.to_keywords, :id))
        case write_query(table.insert(doc)) do
          Result[inserted: 1.0, generated_keys: [key]] ->
            get(key)
          result ->
            result
        end
      end

      @doc false
      def __document__(:table_name) do
        @table_name
      end

      defp table do
        r.table(__document__(:table_name))
      end

      defp write_query(query) do
        case run_query(query) do
          {:ok, result} ->
            Result.new(convert_keys_to_atom(result.to_list))
          error ->
            error
        end
      end

      defp find_query(query) do
        case run_query(query) do
          {:ok, result} when is_record(result, HashDict) ->
            apply(__MODULE__, :new, [convert_keys_to_atom(result.to_list)])
          error ->
            error
        end
      end

      defp convert_keys_to_atom(dict) do
        Enum.map(dict, fn {key, value} -> {:'#{key}', value} end)
      end

      defp run_query(query, try // 0) do
        case r(query) do
          {:error, _, :RUNTIME_ERROR, {:backtrace, [{:frame, :POS, 0, :undefined}]}} ->
            case r(r.table_create(__document__(:table_name))) do
              {:ok, result} when try == 0 ->
                run_query(query, 1)
              error -> error
            end
          result -> result
        end
      end
    end
  end

  def table_name(module) do
    Inflector.tableize(List.last(Module.split(module)))
  end
end
