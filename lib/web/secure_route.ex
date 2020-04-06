# defmodule Web.SecureRoute do

#   def call(%Plug.Conn{request_path: _path} = conn, _opts) do
#     conn
#     |> get_auth_header
#     |> authenticate
#   end

#   defp send_401(conn, data \\ %{message: "Incorrect authentication token"}) do
#     conn
#     |> send_resp(401, Poison.encode!(data))
#     |> halt
#   end

#   # defp get_auth_header(conn) do
#   #   csa
#   # end
# end
