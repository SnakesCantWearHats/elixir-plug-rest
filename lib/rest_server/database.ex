defmodule RestServer.Database do

  def run_constraints do
    User.Repo.create_constraints()
  end
end
