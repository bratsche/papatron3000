defmodule Papatron3000.Visits.Visit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "visits" do
    field :requested_date, :date
    field :minutes, :integer
    field :tasks, {:array, :string}, default: []

    belongs_to :user, Papatron3000.Users.User

    timestamps()
  end

  @doc false
  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [:requested_date, :minutes, :tasks])
    |> validate_required([:requested_date, :minutes, :user_id])
  end
end
