# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :foosball,
  ecto_repos: [Foosball.Repo]

config :foosball, event_stores: [Foosball.EventStore]

# Configures the endpoint
config :foosball, FoosballWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LwV1yl31AWm0eyGlaijJMqZ/tuhqoNXpMDSR/J8AU1VmSGU/CzOU2QCpTUIAL/+z",
  render_errors: [view: FoosballWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Foosball.PubSub,
  live_view: [signing_salt: "NcXjPGUG"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
