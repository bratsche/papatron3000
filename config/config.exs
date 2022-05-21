import Config

config :papatron3000,
  ecto_repos: [Papatron3000.Repo]

import_config("#{Mix.env()}.exs")
