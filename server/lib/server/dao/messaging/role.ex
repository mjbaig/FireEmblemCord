defmodule Server.Dao.Messaging.Role do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:role_id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "roles" do
    field(:role_name, :string)
    field(:can_write, :boolean, default: false)
    field(:can_read, :boolean, default: false)
    field(:can_create, :boolean, default: false)
    field(:can_emote, :boolean, default: false)

    belongs_to(
      :channel,
      Server.Dao.Messaging.Channel,
      foreign_key: :channel_id,
      references: :channel_id,
      type: :binary_id
    )

    has_many(
      :user_roles,
      Server.Dao.Messaging.UserRole,
      foreign_key: :role_id
    )

    timestamps()
  end

  def changeset(role, attrs) do
    role
    |> cast(attrs, [
      :role_name,
      :can_write,
      :can_read,
      :can_create,
      :can_emote,
      :channel_id
    ])
    |> validate_required([:role_name, :channel_id])
  end
end
