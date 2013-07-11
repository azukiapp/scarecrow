defmodule Scarecrow.Dynamo do
  use Dynamo
  require Lager

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

  initializer :database do
    config = Scarecrow.Dynamo.config[:rethinkdb]

    # Database config sets
    :application.set_env(:lethink, :timeout, 60000)
    :lethink.add_pool(:azuki, 5, [ database: config[:host], port: config[:port] ])
    :lethink.use(:azuki, config[:database])

    # Database connection test
    {:ok, _} = :lethink.query(:azuki, [{:table_list}])
    Lager.info("Connection with #{config[:database]} established")
  end

  # Default functionality available in templates
  templates do
    use Dynamo.Helpers
  end
end
