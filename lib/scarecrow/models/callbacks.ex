defmodule Scarecrow.Models.Callbacks do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)

      Module.register_attribute __MODULE__, :callbacks, accumulate: true
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro set_callback(functions, type, callback) do
    quote bind_quoted: binding do
      @callbacks [functions, type, callback]
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      Enum.each(@callbacks, fn [functions, type, callback] ->
        Enum.each(functions, fn {fun, arity} ->
          args = Enum.map(1..arity, fn arg ->
            {:'a#{arg}', [], Elixir}
          end)

          body = unquote(__MODULE__).body(type, args, arity, callback)

          defoverridable [{fun, arity}]
          def fun, args, [], do: body
        end)
      end)
    end
  end

  def body(:before, args, arity, callback) do
    quote do
      result = apply(__MODULE__, unquote(callback), [unquote_splicing(args)])
      [unquote_splicing(args)] = unquote(arity) > 1 && result || [result]
      super(unquote_splicing(args))
    end
  end
end
