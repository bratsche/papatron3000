defmodule Papatron3000.Repo.Migrations.AddVisits do
  use Ecto.Migration

  def change do
    create table(:visits) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :requested_date, :date, null: false
      add :minutes, :integer, null: false
      add :tasks, {:array, :string}, null: false, default: []

      timestamps()
    end
  end
end
