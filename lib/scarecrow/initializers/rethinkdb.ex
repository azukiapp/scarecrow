defmodule Scarecrow.Initializers.Rethinkdb do
  require Lager

  def init do
    url = Scarecrow.Config.get(:rethinkdb_url)
    case URI.parse(url) do
      URI.Info[scheme: "rethinkdb", host: host, port: port, path: path] ->
        # Connection sets
        :application.set_env(:lethink, :timeout, 60000)
        :lethink.add_pool(:azuki, 5, [ database: host, port: port ])

        # Database name
        database = List.last(String.split(path, "/"))
        :lethink.use(:azuki, database)

        # Database connection test
        {:ok, _} = :lethink.query(:azuki, [{:table_list}])
        Lager.info("Connection with #{database} established")
      _ ->
        throw "Invalid rethinkdb url connect: #{url}"
    end
  end
end
