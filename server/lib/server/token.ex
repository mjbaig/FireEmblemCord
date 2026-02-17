defmodule Server.Token do
  use Joken.Config

  @impl true
  def token_config do
    default_claims(
      skip: [:aud, :iss],
      # 1 hour expiration
      default_exp: 3600
    )
  end

  def generate(account_id) do
    claims = %{"account_id" => account_id}
    generate_and_sign(claims)
  end

  def verify_and_extract_account_id(token) do
    case verify_and_validate(token) do
      {:ok, claims} ->
        case claims["account_id"] do
          nil -> {:error, :invalid_token}
          account_id -> {:ok, account_id}
        end

      {:error, _} ->
        {:error, :invalid_token}
    end
  end
end
