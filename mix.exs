defmodule Scarecrow.Mixfile do
  use Mix.Project

  def project do
    [ app: :scarecrow,
      version: "0.0.1",
      elixir: "~> 0.10.0",
      dynamos: [Scarecrow.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/scarecrow/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: applications(Mix.env),
      mod: { Scarecrow, [] },
      included_applications: [:exdocker],
      env: ListDict.merge([
        lager: [ colored: true ],
        rethinkdb_url: {:from_env, :RETHINKDB_URL, "rethinkdb://localhost:28015/azuki"}
      ], env(Mix.env))]
  end

  def applications(:test) do
    [:crypto, :lexthink, :cowboy, :dynamo, :httpotion]
  end

  def applications(_) do
    [:exlager] ++ applications(:test)
  end

  def env(:test) do
    [rethinkdb_url: {:from_env, :RETHINKDB_URL, "rethinkdb://localhost:28015/azuki_test"}]
  end

  def env(_), do: []

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, github: "elixir-lang/dynamo" },
      { :exlager, github: "azukiapp/exlager" },
      { :inflector, github: "azukiapp/inflector" },
      { :uuid, "0.4.4", [github: "avtobiff/erlang-uuid", tag: "v0.4.4"]},
      { :jsx, github: "talentdeficit/jsx", compile: "rebar compile", override: true },
      { :mix_protobuffs, "~> 0.9.0", github: "nuxlli/mix_protobuffs", branch: "fixing_output_ebin", override: true},
      { :lexthink, github: "azukiapp/lexthink", branch: "add_filter" },
      { :"elixir-date", github: "alco/elixir-datetime" },
      { :exdocker, github: "azukiapp/exdocker"} ]
  end
end
