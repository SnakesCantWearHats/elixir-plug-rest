defmodule Login.Logic do
  def register(conn) do
    try do
      user = conn.body_params

      if !user["email"] || !user["password"] do
        {:error, "Email or password missing"}
      else
        new_user = User.Repo.create_user(%{email: user["email"] , password: user["password"]})
        %{success: true, user: new_user}
      end
    rescue
      Bolt.Sips.Exception -> {:error, "User already exists"}
      _ -> {:error, "Error occurred"}
    end
  end

  def get_user(conn) do
    try do
      query = Plug.Conn.Query.decode(conn.query_string)
      if !query["email"] do
        {:error, "Email missing"}
      else
        new_user = User.Repo.get_user_by_email(query["email"])
        %{success: true, user: User.Repo.remove_password_from_response new_user}
      end
    rescue
      Bolt.Sips.Exception -> {:error, "User not found"}
      _ -> {:error, "Error occurred"}
    end
  end

  def get_all_user(conn) do
    try do
      query = Plug.Conn.Query.decode(conn.query_string)
      if !query["limit"] || !query["page"] do
        users = User.Repo.get_users()
        %{success: true, users: users}
      else
        {page, _} = Integer.parse(query["page"])
        {limit, _} = Integer.parse(query["limit"])
        users = User.Repo.get_users(limit, page * limit)
        %{success: true, users: users}
      end
    rescue
      Bolt.Sips.Exception -> {:error, "User not found"}
      _ -> {:error, "Error occurred"}
    end
  end

  def login(conn) do
    try do
      login = conn.body_params

      if !login["email"] || !login["password"] do
        {:error, "Credentials missing"}
      else
        user = User.Repo.get_user_by_email(login["email"])

        if !Login.Encryption.check_password(login["password"], user.properties["password"]) do
          raise "WrongPassword"
        end
        token_claims = %{"email" => login["email"]}
        token = Login.Token.generate_and_sign!(token_claims)
        %{token: token}
      end
    rescue
      e in RuntimeError -> {:error, e.message}
      Bolt.Sips.Exception -> {:error, "User not found"}
      error ->
        IO.inspect error
        {:error, "Error occurred"}
      # _ -> {:error, "Error occurred"}
    end
  end
end
