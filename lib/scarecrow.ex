defmodule Scarecrow do
  use Application.Behaviour
  require Lager

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    config = Scarecrow.Dynamo.config[:rethinkdb]

    # Database config sets
    :application.set_env(:lethink, :timeout, 60000)
    :lethink.add_pool(:azuki, 5, [ database: config[:host], port: config[:port] ])
    :lethink.use(:azuki, config[:database])

    # Database connection test
    {:ok, _} = :lethink.query(:azuki, [{:table_list}])
    Lager.info("Connection with #{config[:database]} established")

    Scarecrow.Dynamo.start_link([max_restarts: 5, max_seconds: 5])
  end
end
