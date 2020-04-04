defmodule RestServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    IO.puts "Starting server"
    children = [
      # Starts a worker by calling: RestServer.Worker.start_link(arg)
      # {RestServer.Worker, arg}
      # {Bolt.Sips, Application.get_env(:bolt_sips, Bolt)},
      {Plug.Cowboy, scheme: :http, plug: RestServer, options: [port: 4000]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RestServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
