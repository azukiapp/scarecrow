defmodule BaseRouter do
  defmacro __using__(_) do
    quote do
      use Dynamo.Router
    end
  end
end
