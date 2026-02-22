# Caches most recent messages to memeory
# Loads history at start up
defmodule Server.Impl.MessageStore do
  import Ecto.Query

  use GenServer

  alias Server.Repo
  alias Server.Dao.Messaging.Message

  # api
  def start_link(_) do
    GenServer.start_link(
      __MODULE__,
      %{
        messages: [],
        nextId: 1
      },
      name: __MODULE__
    )
  end

  def reset do
    GenServer.call(__MODULE__, :reset)
  end

  def store_message(%{"accountId" => account_id, "threadId" => thread_id, "body" => body}) do
    GenServer.call(__MODULE__, {:store, account_id, thread_id, body})
  end

  def get_messages_after(%{
        "timestamp" => timestamp,
        "threadId" => thread_id,
        "page" => page
      }) do
    GenServer.call(__MODULE__, {:after, timestamp, thread_id, page})
  end

  # callbacks

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:store, account_id, thread_id, body}, _from, state) do
    changeset =
      Message.changeset(%Message{}, %{
        body: body,
        metadata: %{},
        thread_id: thread_id,
        creator_id: account_id
      })

    result = Repo.insert(changeset)

    case result do
      {:ok, _} ->
        {:reply, :ok, state}

      {:error, _} ->
        {:reply, :error, state}
    end
  end

  @impl true
  def handle_call({:after, timestamp, thread_id, page}, _from, state) do
    messages =
      Message
      |> where([m], m.thread_id == ^thread_id)
      |> where([m], m.inserted_at > ^timestamp)
      |> order_by([m], asc: m.inserted_at)
      |> limit(20)
      |> offset(^page * 20)
      |> Repo.all()

    {:reply, messages, state}
  end

  def handle_call(:reset, _from, _state) do
    {:reply, :ok, %{messages: [], nextId: 1}}
  end
end
