defmodule Server.WebsocketHandler do
  def init(_args) do
    {:ok, %{accountId: nil}}
  end

  def handle_in({message, _opts}, state) do
    case Jason.decode(message) do
      {:ok, %{"type" => "auth", "accountId" => accountId}} ->
        handle_auth(accountId, state)

      {:ok, data} ->
        handle_client_message(data, state)

      _ ->
        {:ok, state}
    end
  end

  def handle_info({:broadcast, data}, state) do
    {:push, {:text, Jason.encode!(data)}, state}
  end

  def handle_connect(_conn, state) do
    {:ok, state}
  end

  def handle_disconnect(_reason, %{accountId: accountId} = state) do
    if accountId do
      Server.ClientRegistry.unregister(accountId, self())
    end

    {:ok, state}
  end

  defp handle_auth(accountId, state) do
    # register connection to user
    # TODO actually auth the user lol
    Server.ClientRegistry.register(accountId, self())

    send_unseen_messages(accountId)

    {:ok, %{state | account: accountId}}
  end

  def handle_client_message(data, %{accountId: accountId} = state) do
    data = Map.put(data, "accountId", accountId)

    Server.MessageStore.store_message(data)

    Server.ClientRegistry.broadcast_global(data)

    {:ok, state}
  end

  # TODO
  def send_unseen_messages(lastSeenId) do
    Server.MessageStore.get_messages_after(lastSeenId)
    |> Enum.each(fn message ->
      send(self(), {:broadcast, message})
    end)
  end
end
