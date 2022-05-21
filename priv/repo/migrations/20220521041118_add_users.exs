defmodule Papatron3000.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name,  :string, null: false
      add :email,      :string, null: false
      add :balance,    :integer, null: false, default: 60

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
