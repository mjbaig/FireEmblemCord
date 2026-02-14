defmodule Server.Dao.Messaging.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id

  schema "user_roles" do
    belongs_to(:user, Server.Dao.Accounts.User,
      primary_key: true,
      foreign_key: :account_id,
      references: :account_id
    )

    belongs_to(:role, Server.Dao.Messaging.Role,
      primary_key: true,
      references: :role_id
    )

    timestamps()
  end

  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:account_id, :role_id])
    |> validate_required([:account_id, :role_id])
    |> unique_constraint([:account_id, :role_id])
  end
end
