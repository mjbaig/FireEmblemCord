defmodule Server.Service.MessageStoreTest do
  alias Server.MessageStore
  use ExUnit.Case, async: false

  alias Server.Service.MessageStoreService

  setup do
    MessageStoreService.reset()
    Ecto.Adapters.SQL.Sandbox.checkout(Server.Repo)
    :ok
  end

  test "stores a message and assigns sequential ids" do
    message1 =
      MessageStoreService.store_message(%{
        "accountId" => Ecto.UUID.generate(),
        "threadId" => 1,
        "body" => "hello"
      })

    message2 =
      MessageStoreService.store_message(%{
        "accountId" => Ecto.UUID.generate(),
        "threadId" => 1,
        "body" => "world"
      })

    IO.inspect(message1)
  end
end
