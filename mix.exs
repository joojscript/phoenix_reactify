defmodule PhoenixReactify.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_reactify,
      version: "0.0.5",
      elixir: "~> 1.12",
      escript: [main_module: PhoenixReactify],
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

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Phoenix Reactify is an open-source tool meant to add a simple React implementation to fresh Phoenix Applications."
  end

  defp package() do
    [
      name: "phoenix_reactify",
      files: ~w(lib deps test _build .formatter.exs mix.exs README*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/joojscript/phoenix_reactify"}
    ]
  end
end
