defmodule Server.WebsocketIntegrationTest do
  use ExUnit.Case, async: false
  use WebSockex

  alias Server.Token

  def create_jwt() do
    case Token.generate(Ecto.UUID.generate()) do
      {:ok, token, _claims} ->
        token
    end
  end

  def start_link(token, test_pid) do
    WebSockex.start_link("ws://localhost:4000/ws?#{token}", __MODULE__, test_pid)
  end

  test "responds to ping" do
    token = create_jwt()

    {:ok, pid} = Server.WebsocketIntegrationTest.start_link(token, self())

    WebSockex.send_frame(
      pid,
      {:text, ~s({"type":"ping"})}
    )

    assert_receive {:ws_message, response}

    assert response =~ "pong"
  end

  def handle_frame({:text, msg}, test_pid) do
    send(test_pid, {:ws_message, msg})
    {:ok, test_pid}
  end
end
