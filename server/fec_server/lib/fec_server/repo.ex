defmodule FecServer.Repo do
  use Ecto.Repo,
    otp_app: :fec_server,
    adapter: Ecto.Adapters.Postgres
end
