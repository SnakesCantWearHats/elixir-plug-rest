defmodule User.Repo do
  def create_user(%{email: email, password: password}) do
    entry = Bolt.Sips.conn()
      |> Bolt.Sips.query!("CREATE (user:User{email: '#{email}', password: '#{Login.Encryption.encrypt_password(password)}'}) RETURN user")
      |> Bolt.Sips.Response.first()
    IO.inspect entry["user"]
    remove_password_from_response entry["user"]
  end

  def get_user_by_email(user_email) do
    entry = Bolt.Sips.conn()
      |> Bolt.Sips.query!("MATCH (user:User{email: '#{user_email}'}) RETURN user")
      |> Bolt.Sips.Response.first()
    entry["user"]
  end

  def get_users(limit \\ 25, skip \\ 0) do
    IO.inspect limit
    users = Bolt.Sips.conn()
      |> Bolt.Sips.query!("MATCH (user:User) RETURN user SKIP #{skip} LIMIT #{limit}")
    users.results |> Enum.map(fn item -> remove_password_from_response item["user"] end)
  end

  def create_constraints do
    Bolt.Sips.conn()
      |> Bolt.Sips.query!("CREATE CONSTRAINT ON (u:User) ASSERT u.email IS UNIQUE")
  end

  def remove_password_from_response (user) do
    {_, new_map} = pop_in(user, [Access.key!(:properties), Access.key!("password")])
    new_map
  end
end
