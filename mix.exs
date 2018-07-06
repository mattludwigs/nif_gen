defmodule NifGen.MixProject do
  use Mix.Project

  def project do
    [
      app: :nif_gen,
      version: "1.0.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp description,
    do: """
    Generate an Elixir project with a nif.
    """

  defp package,
    do: [
      files: ["lib", "LICENSE", "mix.exs", "README.md", "templates"],
      licenses: ["MIT"],
      maintainers: ["Connor Rigby"],
      links: %{"GitHub" => "https://github.com/connorrigbyy/nif_gen"},
      source_url: "https://github.com/connorrigbyy/nif_gen",
      homepage_url: "https://github.com/connorrigbyy/nif_gen"
    ]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.18.3", only: :dev},
    ]
  end
end
