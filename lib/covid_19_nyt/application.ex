defmodule Covid19.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # List all child processes to be supervised
    children = [
      Covid19.Scheduler,
      # Start the Ecto repository
      Covid19.Repo,
      # Start the endpoint when the application starts
      Covid19Web.Endpoint,
      {Covid19.Update.EtagAgent, %{}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Covid19.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Covid19Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
