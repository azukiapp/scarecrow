defmodule Scarecrow.Models.Document do
  defmacro __using__(opts) do
    self = opts[:self] || :self
    quote do
      import unquote(__MODULE__)

      Module.register_attribute __MODULE__, :before_new, accumulate: true
      Module.register_attribute __MODULE__, :after_new, accumulate: true
      Module.register_attribute __MODULE__, :fields, accumulate: true

      @record_seted false
      @record_self unquote(self)

      @after_new { unquote(__MODULE__), :__after_new__ }
      @before_compile unquote(__MODULE__)

      use Scarecrow.Models.DefTrigger, trigger: { unquote(__MODULE__), :def_trigger }
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      unquote(def_trigger)
      defoverridable [new: 1]
      def new(values) do
        Enum.reduce(@after_new, super(values), fn ({module, func}, record) ->
          apply(module, func, [record])
        end)
      end
    end
  end

  def __after_new__(record) do
    record
  end

  defmacro field(name, opts // []) do
    default = opts[:default]
    quote do
      Module.put_attribute __MODULE__, :fields, {:'#{unquote(name)}', unquote(default)}
    end
  end

  # Record functions override protection
  def def_trigger do
    quote do
      unless @record_seted do
        @record_seted true
        Record.deffunctions(Keyword.merge(@fields, [_id: nil]), __ENV__)

        Record.import __MODULE__, as: @record_self
      end
    end
  end
end
