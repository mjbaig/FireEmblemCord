defmodule Server.Service.ThreadService do
  import Ecto.Query

  use GenServer

  alias Server.Repo

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

  def handle_call(:reset, _from, _state) do
    {:reply, :ok, %{messages: [], nextId: 1}}
  end
end
