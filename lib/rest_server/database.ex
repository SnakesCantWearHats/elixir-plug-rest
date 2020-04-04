defmodule RestServer.Database do
  alias Bolt.Sips, as: DB

  def start_link() do
    {:ok, _neo} = DB.start_link(url: "bolt://neo4j:needs-based\ AI\ teal\ 51@neo4j:7687")
    IO.puts "Connected to database"

    pid = spawn_link(fn -> loop(DB.conn) end)
    Process.register(pid, :neo4j)
  end

  def query(query) do
    conn = :neo4j |> send(self())
    DB.query!(conn, query)
  end

  defp loop(conn) do
    receive do
      caller ->
        caller |> send(conn)
        loop conn
    end
  end
end
