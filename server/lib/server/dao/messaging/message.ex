defmodule Server.Dao.Messaging.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:message_id, :id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "messages" do
    field(:body, :string)

    field(:metadata, :map)

    belongs_to(:thread, Server.Dao.Messaging.Thread,
      references: :thread_id,
      type: :binary_id
    )

    belongs_to(:creator, Server.Dao.Accounts.User,
      references: :account_id,
      type: :binary_id
    )

    timestamps(inserted_at: :created_at, updated_at: false)
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :metadata, :thread_id, :creator_id])
    |> validate_required([:body, :thread_id, :creator_id])
  end
end
