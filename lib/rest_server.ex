defmodule RestServer do
  import Plug.Conn

  def init(options) do
    Process.sleep(10_000)
    {:ok, _neo} = Bolt.Sips.start_link(url: Application.get_env(:bolt_sips, :url))
    IO.puts "Connected to neo4j database"
    RestServer.Database.run_constraints()

    options
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> Router.call(Router.init([]))
  end
end
