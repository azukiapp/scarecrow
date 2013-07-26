defmodule Scarecrow.Models.Document do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      import Kernel, except: [def: 2, def: 4, defp: 2, defp: 4]

      Module.register_attribute __MODULE__, :before_new, accumulate: true
      Module.register_attribute __MODULE__, :after_new, accumulate: true
      Module.register_attribute __MODULE__, :fields, accumulate: true

      @record_seted false
      #@before_new { unquote(__MODULE__), :__before_new__ }
      @after_new { unquote(__MODULE__), :__after_new__ }
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
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

  # Protection for record creation
  @doc false
  defmacro def(name, contents) do
    quote do
      unquote(check_record_set)
      Kernel.def(unquote(name), unquote(contents))
    end
  end

  @doc false
  defmacro def(name, args, guards, contents) do
    quote do
      unquote(check_record_set)
      Kernel.def(unquote(name), unquote(args), unquote(guards), unquote(contents))
    end
  end

  @doc false
  defmacro defp(name, contents) do
    quote do
      unquote(check_record_set)
      Kernel.defp(unquote(name), unquote(contents))
    end
  end

  @doc false
  defmacro defp(name, args, guards, contents) do
    quote do
      unquote(check_record_set)
      Kernel.defp(unquote(name), unquote(args), unquote(guards), unquote(contents))
    end
  end

  defp check_record_set do
    quote do
      unless @record_seted do
        @record_seted true
        Record.deffunctions(Keyword.merge(@fields, [_id: nil]), __ENV__)
        defoverridable Enum.map(@fields, fn {k, _} ->
          {k, 2}
        end)
        defoverridable Enum.map(@fields, fn {k, _} ->
          {k, 1}
        end)
      end
    end
  end
end
