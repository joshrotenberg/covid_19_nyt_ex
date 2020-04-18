use Mix.Config

config :covid_19_nyt,
  namespace: Covid19,
  ecto_repos: [Covid19.Repo]

config :covid_19_nyt, Covid19Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "n6oCNyDBfApt1QSSlVBSFFvxUZMVWWuL6Tp9H1QG2hs0Voxp9uLefN+zo+u/lnU3",
  render_errors: [view: Covid19Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Covid19.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "p9R8dPV5"]

config :logger, :debug,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :covid_19_nyt, Covid19.Scheduler,
  jobs: [
    {"@hourly", {Covid19.Update.State, :update_states, []}},
    {"@hourly", {Covid19.Update.County, :update_counties, []}},
    {"@hourly", {Covid19.Update.US, :update_us, []}}
  ]

import_config "#{Mix.env()}.exs"
