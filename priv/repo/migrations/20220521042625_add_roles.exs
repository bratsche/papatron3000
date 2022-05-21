defmodule Papatron3000.Repo.Migrations.AddRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :type, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:roles, [:user_id, :type])
  end
end
