defmodule Stash.MixProject do
  use Mix.Project

  def project do
    [
      app: :stash,
      version: "1.0.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Stash.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:atomize_keys, "~> 1.1"},
      {:confex, "~> 3.4.0"},
      {:bcrypt_elixir, "~> 2.2"},
      {:commanded, "~> 1.1"},
      {:commanded_eventstore_adapter, "~> 1.0.0"},
      {:commanded_ecto_projections, "~> 1.0"},
      {:cors_plug, "~> 1.4"},
      {:elixir_uuid, "~> 1.2"},
      {:ex_machina, "~> 2.3", only: :test},
      {:eventstore, "~> 1.0.0"},
      {:ecto_sql, "~> 3.4"},
      {:faker, "~> 0.13", only: :test},
      {:floki, ">= 0.0.0", only: :test},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.5.0"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_view, "~> 0.12.0"},
      {:phoenix_live_dashboard, "~> 0.2.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:postgrex, ">= 0.14.3"},
      {:plug_cowboy, "~> 2.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "store.setup": ["event_store.create", "event_store.init"],
      "store.reset": ["event_store.drop", "store.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "store.init": ["ecto.create", "store.reset", "ecto.migrate"],
      test: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "store.reset",
        "test"
      ]
    ]
  end
end
