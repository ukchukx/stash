# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :stash,
  ecto_repos: [Stash.Repo]

# Configures the endpoint
config :stash, Stash.Web.Endpoint,
  url: [host: {:system, "STASH_DNS_ADDR"}],
  secret_key_base: {:system, "STASH_SECRET_KEY_BASE"},
  render_errors: [view: Stash.Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Stash.PubSub,
  live_view: [signing_salt: "Oky+4yOc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
