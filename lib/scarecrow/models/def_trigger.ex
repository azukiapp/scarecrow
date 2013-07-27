defmodule Scarecrow.Models.DefTrigger do
  defmacro __using__(opts) do
    quote do
      @def_trigger unquote(opts[:trigger])
      import Kernel, except: [def: 2, def: 4, defp: 2, defp: 4, defoverridable: 1]
      import unquote(__MODULE__)
    end
  end

  defp trigger do
    quote do
      {module, func} = @def_trigger
      Module.eval_quoted __MODULE__, apply(module, func, [])
    end
  end

  @doc false
  defmacro defoverridable(functions) do
    quote do
      unquote(trigger)
      Kernel.defoverridable(unquote(functions))
    end
  end

  @doc false
  defmacro def(name, contents) do
    quote do
      unquote(trigger)
      Kernel.def(unquote(name), unquote(contents))
    end
  end

  @doc false
  defmacro def(name, args, guards, contents) do
    quote do
      unquote(trigger)
      Kernel.def(unquote(name), unquote(args), unquote(guards), unquote(contents))
    end
  end

  @doc false
  defmacro defp(name, contents) do
    quote do
      unquote(trigger)
      Kernel.defp(unquote(name), unquote(contents))
    end
  end

  @doc false
  defmacro defp(name, args, guards, contents) do
    quote do
      unquote(trigger)
      Kernel.defp(unquote(name), unquote(args), unquote(guards), unquote(contents))
    end
  end
end
