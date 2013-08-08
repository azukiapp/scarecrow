Code.require_file "utils/pride_formatter.exs", __DIR__

Dynamo.under_test(Scarecrow.Dynamo)
Dynamo.Loader.enable
ExUnit.start # formatter: Scarecrow.Test.PrideFormatter

defmodule Scarecrow.TestCase do
  use ExUnit.CaseTemplate

  defmacro __using__(opts) do
    async  = Keyword.get(opts, :async, false)
    parent = Keyword.get(opts, :parent, ExUnit.Case)
    target = Keyword.get(opts, :target, nil)

    quote do
      use ExUnit.Case, async: unquote(async), parent: unquote(parent)
      import unquote(__MODULE__)

      if unquote(target) != nil do
        @target unquote(target)
      end

      # Enable code reloading on test cases
      setup do
        Dynamo.Loader.enable
        :ok
      end
    end
  end

  defmacro halted(contents) do
    quote do
      try do
        unquote(contents)
      catch
        :throw, {:halt!, result} ->
          result
      end
    end
  end
end
