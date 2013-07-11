defmodule Scarecrow.Mixfile do
  use Mix.Project

  def project do
    [ app: :scarecrow,
      version: "0.0.1",
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
      env: [
        lager: [ colored: true ]
      ]]
  end

  def applications(:test) do
    [:lethink, :cowboy, :dynamo]
  end

  def applications(_) do
    [:exlager] ++ applications(:test)
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, github: "elixir-lang/dynamo" },
      { :exlager, github: "azukiapp/exlager" },
      { :jsx, github: "talentdeficit/jsx", compile: "rebar compile" },
      { :lethink, github: "taybin/lethink" }]
  end
end
