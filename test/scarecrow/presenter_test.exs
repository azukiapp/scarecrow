Code.require_file "../test_helper.exs", __DIR__

defmodule ScarecrowPresenterTest do
  use ExUnit.Case

  defmodule OrderPresenter do
    use Scarecrow.Presenter

    property :currency
    property :status
    property :total

    link :self do
      "/orders/#{represented[:id]}"
    end
  end

  test "return a valid json representation" do
    result = OrderPresenter.build([])
    assert :jsx.is_json(result)
  end

  test "return a property if is maped" do
    result = :jsx.decode(OrderPresenter.build([ status: "shiped"]))
    assert "shiped", result["status"]
  end

  test "not return a unmaped property" do
    order  = [ status: "shiped", user: 1 ]
    result = :jsx.decode(OrderPresenter.build(order))
    assert "shiped", result["status"]
    refute ListDict.has_key?(result, "user")
  end

  test "return a self link" do
    order  = [ id: 10 ]
    result = :jsx.decode(OrderPresenter.build(order))

    assert Dict.has_key?(result, "_links")
    assert Dict.has_key?(result["_links"], "self")
    assert Dict.equal?(result["_links"]["self"], [ {"href", "/orders/10"} ])
  end
end
