defmodule Server.WebsocketHandlerTest do
  use ExUnit.Case, async: false

  alias Server.WebsocketHandler
  alias Server.Impl.MessageStore

  setup do
    MessageStore.reset()
    :ok
  end
end
