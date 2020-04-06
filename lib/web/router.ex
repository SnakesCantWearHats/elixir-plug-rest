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
    case Login.Logic.register(conn) do
      {:error, message} -> conn |> send_resp(400, Poison.encode!(%{error: message}))
      response -> conn |> send_resp(200, Poison.encode!(response))
    end
  end

  get "/user" do
    case Login.Logic.get_user(conn) do
      {:error, message} -> conn |> send_resp(400, Poison.encode!(%{error: message}))
      response -> conn |> send_resp(200, Poison.encode!(response))
    end
  end

  get "/users" do
    case Login.Logic.get_all_user(conn) do
      {:error, message} -> conn |> send_resp(400, Poison.encode!(%{error: message}))
      response -> conn |> send_resp(200, Poison.encode!(response))
    end
  end

  post "/login" do
    case Login.Logic.login(conn) do
      {:error, message} -> conn |> send_resp(400, Poison.encode!(%{error: message}))
      response -> conn |> send_resp(200, Poison.encode!(response))
    end
  end

  post "/secured_route" do
    %{"token" => token} = conn.body_params

    {:ok, claims} = Login.Token.verify_and_validate(token)

    conn |> send_resp(200, Poison.encode!(claims))
  end

  forward "/tasks", to: Web.Tasks

  match _ do
    conn |> send_resp(404, Poison.encode!(%{ error: "No route found" }))
  end
end
