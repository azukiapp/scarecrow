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
      defoverridable [new: 1]
      def new(values) do
        record = super(Keyword.merge(values, [
          created_at: Date.now,
          updated_at: Date.now,
        ]))
      end
    end
  end
end
