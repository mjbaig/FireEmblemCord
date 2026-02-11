defmodule Server.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  # this listens at port 4000 by default
  get "/ws" do
    WebSockAdapter.upgrade(conn, Server.WebsocketHandler, [], [])
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
