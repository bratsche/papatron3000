defmodule Papatron3000.Visits.Visit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "visits" do
    field :requested_date, :date
    field :minutes, :integer
    field :tasks, {:array, :string}, default: []

    field :date, :string, virtual: true

    belongs_to :user,        Papatron3000.Users.User
    has_one    :transaction, Papatron3000.Visits.Transaction

    timestamps()
  end

  @doc false
  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [:date, :requested_date, :minutes, :tasks])
    |> handle_date_alias()
    |> validate_required([:requested_date, :minutes, :user_id])
  end

  defp handle_date_alias(changeset) do
    case get_field(changeset, :date) do
      nil ->
        changeset

      date ->
        changeset
        |> put_change(:requested_date, Date.from_iso8601!(date))
    end
  end
end
