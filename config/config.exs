# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :covid_19_nyt,
  namespace: Covid19,
  ecto_repos: [Covid19.Repo]

# Configures the endpoint
config :covid_19_nyt, Covid19Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "n6oCNyDBfApt1QSSlVBSFFvxUZMVWWuL6Tp9H1QG2hs0Voxp9uLefN+zo+u/lnU3",
  render_errors: [view: Covid19Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Covid19.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "p9R8dPV5"]

# Configures Elixir's Logger
config :logger, :debug,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :covid_19_nyt, Covid19.Scheduler,
  jobs: [
    {"* * * * *", {Covid19.Update.State, :update_states, []}},
    {"* * * * *", {Covid19.Update.County, :update_counties, []}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
