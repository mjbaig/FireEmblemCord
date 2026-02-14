defmodule Server.Dao.Messaging.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:thread_id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "threads" do
    field(:name, :string)

    belongs_to(:topic, Server.Dao.Messaging.Topic,
      references: :topic_id,
      type: :binary_id
    )

    has_many(
      :messages,
      Server.Dao.Messaging.Message,
      foreign_key: :message_id
    )

    timestamps()
  end

  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:name, :topic_id])
    |> validate_required([:name, :topic_id])
    |> unique_constraint([:topic_id, :name])
  end
end
