defmodule Foosball.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Foosball.Commanded.Application,
      Foosball.Commanded.Handler,
      # Start the Ecto repository
      Foosball.Repo,
      # Start the Telemetry supervisor
      FoosballWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Foosball.PubSub},
      # Start the Endpoint (http/https)
      FoosballWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Foosball.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FoosballWeb.config_change(changed, removed)
    :ok
  end
end
