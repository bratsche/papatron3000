defmodule Papatron3000.Repo do
  use Ecto.Repo,
    otp_app: :papatron3000,
    adapter: Ecto.Adapters.Postgres
end
