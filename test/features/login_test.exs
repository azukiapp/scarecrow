Code.require_file "../../test_helper.exs", __FILE__

# Feature tests goes through the Dynamo.under_test
# and are meant to test the full stack.
defmodule LoginTest do
  use Scarecrow.TestCase
  use Dynamo.HTTP.Case

  @endpoint ApplicationRouter

  def conn do
    (halted conn(:GET, "/")).put_req_header("Accept", "application/json")
  end

  test "return invalid content type" do
    conn = conn.put_req_header("Accept", "text/html")
    conn = halted get(conn, "/login")
    assert conn.status == 406
    assert :jsx.decode(conn.resp_body)["error"] == "Not Acceptable"
  end

  test "return unauthorized withou username or password" do
    conn = halted get(conn, "/login")
    assert conn.status == 401
    conn = halted get(conn, "/login?username=foo")
    assert conn.status == 401
  end
end
