defmodule Inflector do
  @spec tableize(binary | atom) :: binary
  def tableize(term) do
    "#{:inflector.tableize(term)}"
  end
end
