defmodule Papatron3000.Repo.Migrations.AddSession do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :lock, :boolean, null: false, default: true

      timestamps()
    end

    # Ensure that only one session may exist at a time, because this is just
    # a simple CLI app and we don't need multiple sessions. :)
    create unique_index(:sessions, [:lock])
  end
end
