defmodule Scarecrow.Models.Timestamps do
  defmacro __using__(_opts) do
    quote do
      field :created_at
      field :updated_at

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def touch(record) do
        record.updated_at Date.now
      end

      defoverridable [new: 1]
      def new(values) do
        now = Date.now
        record = super(Keyword.merge([
          created_at: now,
          updated_at: now,
        ], values))
      end
    end
  end
end
