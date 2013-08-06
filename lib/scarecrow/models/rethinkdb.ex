defmodule Scarecrow.Models.Rethinkdb do

  defrecord Result,
    generated_keys: [],
    deleted: 0, inserted: 0, replaced: 0, skipped: 0, unchanged: 0,
    new_val: nil, old_val: nil,
    first_error: nil, errors: 0

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
        if new_record?(record) do
          insert(record)
        else
          replace(record)
        end
      end

      def get(key) do
        find_query(table.get(key))
      end

      def insert(record) do
        doc = document_prepare(Keyword.delete(record.to_keywords, :id))
        case write_query(table.insert(doc, return_vals: true)) do
          {:ok, Result[inserted: 1.0, new_val: new_val]} ->
            to_record(new_val)
          result ->
            result
        end
      end

      def replace(record) do
        doc = document_prepare(record.to_keywords)
        case write_query(table.get(record.id).replace(doc)) do
          {:ok, Result[replaced: 1.0] = result} ->
            {:ok, record}
          result ->
            result
        end
      end

      defoverridable [update: 2]
      def update(fields, record) do
        doc = document_prepare(fields)
        case write_query(table.get(record.id).update(doc, return_vals: true)) do
          {:ok, Result[replaced: 1.0, new_val: new_val]} ->
            to_record(new_val)
          result ->
            result
        end
      end

      def table do
        r.table(__document__(:table_name))
      end

      @doc false
      def __document__(:table_name) do
        @table_name
      end

      # Private session
      defp write_query(query) do
        to_record(run_query(query), Result)
      end

      defp find_query(query) do
        to_record(run_query(query))
      end

      defp to_record(data) do
        to_record(data, __MODULE__)
      end

      defp to_record({:ok, data}, record_type) do
        to_record(data, record_type)
      end

      defp to_record(data, record_type) when is_record(data, HashDict) do
        {:ok, apply(record_type, :new, [convert_keys_to_atom(data.to_list)])}
      end

      defp to_record(data, record_type) do
        data
      end

      defp convert_keys_to_atom(dict) do
        Enum.map(dict, fn {key, value} -> {:'#{key}', value} end)
      end

      defp run_query(query, try // 0) do
        case r(query) do
          # Auto table create
          {:error, _, :RUNTIME_ERROR, {:backtrace, [{:frame, :POS, 0, :undefined}]}} ->
            case r(r.table_create(__document__(:table_name))) do
              {:ok, result} when try == 0 ->
                run_query(query, 1)
              error -> error
            end
          result -> result
        end
      end

      defp document_prepare(document) do
        HashDict.new(document)
      end
    end
  end

  def table_name(module) do
    Inflector.tableize(List.last(Module.split(module)))
  end
end
