defmodule Covid19.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Covid19.Scheduler,
      Covid19.Repo,
      Covid19Web.Endpoint,
      {Covid19.Update.EtagAgent, %{}}
    ]

    opts = [strategy: :one_for_one, name: Covid19.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Covid19Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
