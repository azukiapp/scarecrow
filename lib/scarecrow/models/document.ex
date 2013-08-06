defmodule Scarecrow.Models.Document do
  defmacro __using__(opts) do
    self = opts[:self] || :self
    quote do
      import unquote(__MODULE__)

      Module.register_attribute __MODULE__, :before_new, accumulate: true
      Module.register_attribute __MODULE__, :after_new, accumulate: true

      @fields []
      @default_funcs []

      @record_seted false
      @record_self unquote(self)

      @before_compile unquote(__MODULE__)

      use Scarecrow.Models.DefTrigger, trigger: { unquote(__MODULE__), :def_trigger }
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      unquote(def_trigger)
      def_defaults(@default_funcs)
      def_after_new
    end
  end

  defmacro def_after_new do
    quote do
      defoverridable [new: 1]
      def new(values) do
        Enum.reduce(@after_new, super(values), fn
          ({module, func}, record) ->
            apply(module, func, [record])
          (func, record) ->
            apply(__MODULE__, func, [record])
        end)
      end
    end
  end

  defmacro def_defaults(functions) do
    quote bind_quoted: [functions: functions] do
      defoverridable [new: 1]
      def new(values) do
        Enum.reduce(unquote(functions), super(values), fn {field, func}, record ->
          apply(record, field, [func.(record)])
        end)
      end
    end
  end

  defmacro field(name, opts // []) do
    quotes  = []

    # Save default options based in functions
    default = case opts[:default] do
      {:fn, _, _} = default ->
        quotes = [quote do
          @default_funcs Keyword.merge(
            @default_funcs,
            [{unquote(name), unquote(Macro.escape(default))}]
          )
        end]
        nil
      value -> value
    end

    quotes ++ [quote do
      @fields Keyword.merge(
        @fields,
        [{:'#{unquote(name)}', unquote(default)}]
      )
    end]
  end

  # Record functions override protection
  def def_trigger do
    quote do
      unless @record_seted do
        @record_seted true
        Record.deffunctions(@fields, __ENV__)

        Record.import __MODULE__, as: @record_self
      end
    end
  end
end
