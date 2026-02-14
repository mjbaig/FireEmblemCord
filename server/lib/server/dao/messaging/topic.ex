defmodule Server.Dao.Messaging.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:topic_id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "topics" do
    field(:name, :string)

    belongs_to(:channel, Server.Dao.Messaging.Channel,
      foreign_key: :channel_id,
      references: :channel_id,
      type: :binary_id
    )

    has_many(:threads, Server.Dao.Messaging.Thread, foreign_key: :thread_id)

    timestamps()
  end

  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:name, :channel_id])
    |> validate_required([:name, :channel_id])
    |> unique_constraint([:channel_id, :name])
  end
end
