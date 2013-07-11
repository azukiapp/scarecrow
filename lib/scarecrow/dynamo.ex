defmodule Scarecrow.Dynamo do
  use Dynamo

  config :dynamo,
    # The environment this Dynamo runs on
    env: Mix.env,

    # The OTP application associated to this Dynamo
    otp_app: :scarecrow,

    # The endpoint to dispatch requests to
    endpoint: ApplicationRouter,

    # The route from where static assets are served
    # You can turn off static assets by setting it to false
    static_route: "/static"

  # Uncomment the lines below to enable the cookie session store
  # config :dynamo,
  #   session_store: Session.CookieStore,
  #   session_options:
  #     [ key: "_scarecrow_session",
  #       secret: "yyeXyTOifQ2H4w6WGq3nr2Su3NP2xmK44MscxqIN1ugBnRNyFllpHeY4iovqD3pw"]

  config :rethinkdb,
    database: "azuki",
    host: "localhost",
    port: 28015

  # Default functionality available in templates
  templates do
    use Dynamo.Helpers
  end
end
