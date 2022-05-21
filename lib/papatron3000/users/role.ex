defmodule Papatron3000.Users.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :type, Ecto.Enum, values: [:member, :pal]

    belongs_to :user, Papatron3000.Users.User

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:type])
    |> validate_required([:type])
  end
end
