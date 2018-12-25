defmodule TpIasc.MixProject do
  use Mix.Project

  def project do
    [
      app: :tp_iasc,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger
      ],
      mod: {TpIasc, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:amnesia, github: "meh/amnesia", branch: "master", override: true},
      {:exquisite, github: "meh/exquisite", branch: "master", override: true},
      # {:syncm, git: "https://github.com/jpiepkow/syncm", app: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
