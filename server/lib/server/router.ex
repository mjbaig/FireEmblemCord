defmodule Server.Router do
  use Plug.Router

  use Plug.ErrorHandler

  if Mix.env() == :dev || Mix.env() == :test do
    use Plug.Debugger
  end

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  alias Server.Impl.Auth

  # this listens at port 4000 by default
  get "/ws" do
    case conn.params["token"] do
      nil ->
        send_resp(conn, 401, "missing token")

      token ->
        verified_token = Server.Token.verify_and_extract_account_id(token)

        case verified_token do
          {:ok, account_id} ->
            WebSockAdapter.upgrade(
              conn,
              Server.WebsocketHandler,
              %{accountId: account_id},
              []
            )

          {:error, _} ->
            send_resp(conn, 401, "invalid token")
        end
    end
  end

  post "/signup" do
    %{"username" => username, "password" => password, "signup_token" => signup_token} =
      conn.body_params

    response = Auth.signup(username, password, signup_token)

    case response do
      {:ok, _} ->
        send_resp(conn, 200, "signed up")

      {:error, _} ->
        send_resp(conn, 401, "failed to sign up")
    end
  end

  post "/login" do
    %{"username" => username, "password" => password} = conn.body_params

    case Auth.login(username, password) do
      {:error, :unauthorized} ->
        send_resp(conn, 401, "invalid credentials homie")

      {:ok, token} ->
        send_json(conn, %{token: token})
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  defp send_json(conn, data) do
    body = Jason.encode!(data)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(200, body)
  end
end
