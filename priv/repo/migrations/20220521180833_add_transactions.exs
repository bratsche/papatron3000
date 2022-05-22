defmodule Papatron3000.Repo.Migrations.AddTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :visit_id, references(:visits, on_delete: :delete_all), null: false
      add :member_id, references(:users, on_delete: :delete_all), null: false
      add :pal_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
