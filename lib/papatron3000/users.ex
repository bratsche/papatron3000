defmodule Papatron3000.Users do
  import Ecto.Query, warn: false
  alias Papatron3000.Repo
  alias Papatron3000.Users.{Role, User}

  @doc """
  Find a user by the given email address.
  """
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Create a new user.
  """
  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def has_role?(%User{} = user, role_type) do
    from(
      r in Role,
      where: r.user_id == ^user.id,
      where: r.type == ^role_type
    )
    |> Repo.all()
    |> Enum.any?()
  end

  @doc """
  Adds the specified role.
  """
  def add_role(%User{} = user, role_type) do
    if has_role?(user, role_type) do
      {:error, "This role is already set."}
    else
      Ecto.build_assoc(user, :roles)
      |> Role.changeset(%{type: role_type})
      |> Repo.insert()
    end
  end
end
