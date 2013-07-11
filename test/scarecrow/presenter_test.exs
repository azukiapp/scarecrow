Code.require_file "../test_helper.exs", __DIR__

defmodule ScarecrowPresenterTest do
  use ExUnit.Case

  defmodule OrderPresenter do
    use Scarecrow.Presenter

    #property
    #property

    link :self do
      "/orders/#{represented[:slug]}"
    end
  end
end
