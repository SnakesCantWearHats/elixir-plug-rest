defmodule Router do
  use Plug.Router
  require Poison

  plug Plug.Logger
  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json", "text/json"],
    json_decoder: Poison
  plug :match
  plug :dispatch

  get "/ping" do
    conn |> send_resp(200, Poison.encode!("pong"))
  end

  post "/register" do
    %{"email" => email, "password" => password} = conn.body_params

    if !email || !password, do: conn |> send_resp(400, Poison.encode!(%{error: "Bad request"}))

    new_user = Login.Store.add_user(%{email: email, password: password})

    case new_user do
      %{error: message} -> conn |> send_resp(400, Poison.encode!(%{error: message}))
      _ -> conn |> send_resp(200, Poison.encode!(%{success: true, message: "User created", user: new_user}))
    end
  end

  get "/user/:id" do
      user = Login.Store.get_user_by_id(id)
      case user do
        :error -> conn |> send_resp(400, Poison.encode!(%{error: "User not found"}))
        _ -> conn |> send_resp(200, Poison.encode!(%{success: true, message: "User found", user: user}))
      end
  end

  get "/users" do
    users = Login.Store.get_users()
    conn |> send_resp(200, Poison.encode!(%{success: true, message: "", users: users}))
  end

  match _ do
    conn |> send_resp(404, Poison.encode!(%{ error: "No route found" }))
  end
end
