defmodule HttpbinProxy.MixProject do
  use Mix.Project

  def project do
    [
      app: :httpbin_proxy,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HttpbinProxy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.6"},
      {:cowboy, "~> 2.0"},
      {:httpoison, "~> 1.0"},
      {:jason, "~> 1.0"},
      {:cachex, "~> 3.0"}
    ]
  end
end
