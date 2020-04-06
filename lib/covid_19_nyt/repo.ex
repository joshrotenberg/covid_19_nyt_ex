defmodule Covid19.Repo do
  use Ecto.Repo,
    otp_app: :covid_19_nyt,
    adapter: Ecto.Adapters.Postgres
end
