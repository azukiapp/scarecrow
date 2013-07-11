Code.require_file "../../test_helper.exs", __FILE__

defmodule ApplicationRouterTest do
  use Scarecrow.TestCase
  use Dynamo.HTTP.Case

  def conn do
    (halted conn(:GET, "/")).put_req_header("Accept", "application/json")
  end

  # Sometimes it may be convenient to test a specific
  # aspect of a router in isolation. For such, we just
  # need to set the @endpoint to the router under test.
  @endpoint ApplicationRouter
end
