defmodule LoginRouter do
  use BaseRouter

  post "/" do
    conn.resp 200, conn.params[:username]
  end
end
