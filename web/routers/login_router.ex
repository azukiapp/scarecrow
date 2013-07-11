defmodule LoginRouter do
  use Dynamo.Router

  post "/" do
    conn.resp 200, conn.params[:username]
  end
end
