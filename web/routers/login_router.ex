defmodule LoginRouter do
  use BaseRouter

  post "/" do
    conn
      .resp_content_type("application/json")
      .resp_charset("utf-8")
      .resp(200, UserPresenter.build([ user: "nuxlli", name: "Everton" ]))
  end
end
