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

  test "returns 404 in JSON" do
    assert get(conn, "/").status == 404
  end

  test "return invalid content type" do
    conn = conn.put_req_header("Accept", "text/html")
    conn = halted post(conn, "/login")
    assert conn.status == 406
    assert :jsx.decode(conn.resp_body)["error"] == "Not Acceptable"
  end

  test "return ok for valid content type" do
    conn = halted post(conn, "/login")
    assert conn.status == 200
  end
end
