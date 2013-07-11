Code.require_file "test_helper.exs", __DIR__

defmodule ScarecrowRepresenterTest do
  use ExUnit.Case

  defmodule OrderPresenter do
    use Scarecrow.Representer

    #property
    #property

    link :self do
      "/orders/#{represented[:slug]}"
    end
  end
end
