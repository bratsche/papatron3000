defmodule Papatron3000.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name,  :string
    field :email,      :string
    field :balance,    :integer, default: 60

    has_many :roles,  Papatron3000.Users.Role
    has_many :visits, Papatron3000.Visits.Visit

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :balance])
    |> validate_required([:first_name, :last_name, :email])
  end
end
