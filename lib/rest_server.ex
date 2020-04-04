defmodule RestServer do
  import Plug.Conn

  def init(options) do
    Login.Store.start_link()
    # RestServer.Database.start_link()

    options
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> Router.call(Router.init([]))
  end
end
