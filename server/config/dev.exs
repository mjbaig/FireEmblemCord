import Config

config :server, Server.Repo,
  database: "aloocord",
  username: "admin",
  password: "admin",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: false,
  pool_size: 10

config :joken, default_signer: "changethis"
