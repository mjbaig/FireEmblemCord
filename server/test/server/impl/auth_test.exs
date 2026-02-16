defmodule Server.Impl.AuthTest do
  use ExUnit.Case, async: false

  alias Server.Impl.Auth

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Server.Repo)
  end

  test "test that creating a user works" do
    user = Auth.signup("test", "test@gmail.com", "password")

    assert Argon2.verify_pass("password", user.password_hash)

    assert user.account_id != nil
    assert user.email == "test@gmail.com"
    assert user.username == "test"
  end

  test "test that creating a user doesn't work if username is nil" do
    # null contraint throws error
    assert_raise Postgrex.Error, fn ->
      user = Auth.signup(nil, "email", "password")
    end
  end

  test "test that creating a user doesn't work if email is nil" do
    # null contraint throws error
    assert_raise Postgrex.Error, fn ->
      user = Auth.signup("username", nil, "password")
    end
  end

  test "test that creating a user doesn't work if password is nil" do
    # This throws an argument error because the password is hashed before being written
    assert_raise ArgumentError, fn ->
      user = Auth.signup("username", "password", nil)
    end
  end

  test "test that login works when user puts in the correct password" do
    user = Auth.signup("test", "test@gmail.com", "password")
    {status, token} = Auth.login("test@gmail.com", "password")

    assert status == :authorized
    assert token != nil

    {status, claims} = Server.Token.verify_and_validate(token)

    assert status == :ok

    assert Map.get(claims, "sub") == user.account_id
  end

  test "test that login does not work when user puts in the incorrect password" do
    Auth.signup("test", "test@gmail.com", "password")
    {status} = Auth.login("test@gmail.com", "wrong")

    assert status == :unauthorized
  end
end
