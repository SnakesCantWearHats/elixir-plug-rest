defmodule Login.Store do
  use Agent

  def start_link() do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add_user(user) do
    existing_user? = Login.Store.get_user_by_email(user.email)
    if existing_user? == :error do
      new_user = %User{id: UUID.uuid1(), email: user.email, password: Login.Encryption.encrypt_password(user.password)}

      :ok = Agent.update(__MODULE__, fn users -> [new_user | users] end)
      Map.drop(new_user, [:password])
    else
      %{error: "User already exists"}
    end
  end

  def get_user_by_email(user_email) do
    user = Agent.get(__MODULE__, fn users -> Enum.find(users, :error, fn item -> item.email == user_email end) end)
    if user != :error do
      Map.drop(user, [:password])
    else
      :error
    end

  end

  def get_user_by_id(user_id) do
    user = Agent.get(__MODULE__, fn users -> Enum.find(users, :error, fn item -> item.id == user_id end) end)
    if user != :error do
      Map.drop(user, [:password])
    else
      :error
    end
  end

  def get_users do
    Agent.get(__MODULE__, fn users -> users end)
    |> Enum.map(fn item -> Map.drop(item, [:password]) end)
  end
end
