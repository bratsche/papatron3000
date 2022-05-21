import Config

config :papatron3000, Papatron3000.Repo,
  database: "papatron3000_test#{System.get_env("MIX_TEST_PARTITION")}",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn
