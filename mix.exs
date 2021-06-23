defmodule PhoenixReactify.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_reactify,
      version: "0.0.1",
      elixir: "~> 1.12",
      escript: [main_module: PhoenixReactify.CLI],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      name: "Phoenix Reactify",
      source_url: "https://github.com/joojscript/phoenix_reactify"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:cli_spinners, "~> 0.1.0"},
      {:jason, "~> 1.2"}
    ]
  end

  defp description() do
    "Phoenix Reactify is an open-source tool meant to add a simple React implementation to fresh Phoenix Applications."
  end

  defp package() do
    [
      name: "phoenix_reactify",
      files: ~w(lib deps test .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog* src),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/joojscript/phoenix_reactify"}
    ]
  end
end
