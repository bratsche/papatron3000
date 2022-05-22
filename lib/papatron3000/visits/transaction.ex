defmodule Papatron3000.Visits.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    belongs_to :member, Papatron3000.Users.User
    belongs_to :pal,    Papatron3000.Users.User
    belongs_to :visit,  Papatron3000.Visits.Visit

    timestamps()
  end

  @doc false
  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [:member_id, :pal_id, :visit_id])
    |> validate_required([:member_id, :pal_id, :visit_id])
  end
end
