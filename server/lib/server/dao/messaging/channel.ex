defmodule Server.Dao.Messaging.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:channel_id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "chat_channels" do
    field(:name, :string)

    has_many(
      :topics,
      Server.Dao.Messaging.Topic,
      foreign_key: :topic_id
    )

    has_many(
      :channel_memberships,
      Server.Dao.Messaging.ChannelMembership,
      foreign_key: :channel_id
    )

    has_many(
      :roles,
      Server.Dao.Messaging.Role,
      foreign_key: :role_id
    )

    timestamps()
  end

  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
