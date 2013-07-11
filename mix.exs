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
    [ applications: [:exlager, :lethink, :cowboy, :dynamo],
      mod: { Scarecrow, [] },
      env: [
        lager: [ colored: true ]
      ]]
  end

  defp deps do
    [ { :cowboy, %r(.*), github: "extend/cowboy" },
      { :dynamo, "0.1.0.dev", github: "elixir-lang/dynamo" },
      { :exlager, %r(.*), github: "khia/exlager" },
      { :jsx, %r(.*), github: "talentdeficit/jsx", compile: "rebar compile" },
      { :lethink, %r(.*), github: "taybin/lethink" }]
  end
end
