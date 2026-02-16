defmodule Server.Impl.Auth do
  alias Server.Dao.Accounts.User
  alias Server.Repo

  def signup(username, email, password) do
    hash = Argon2.hash_pwd_salt(password)

    user = %User{
      account_id: Ecto.UUID.generate(),
      email: email,
      password_hash: hash,
      username: username,
      email_verification_token: Ecto.UUID.generate()
    }

    Server.Repo.insert!(user)
  end

  def login(email, password) do
    case Repo.get_by(Server.Dao.Accounts.User, email: email) do
      nil ->
        {:unauthorized}

      user ->
        if Argon2.verify_pass(password, user.password_hash) do
          {:ok, token, _claims} =
            Server.Token.generate_and_sign(%{"sub" => user.account_id})

          {:authorized, token}
        else
          {:unauthorized}
        end
    end
  end
end
