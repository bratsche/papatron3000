defmodule Papatron3000.Users do
  import Ecto.Query, warn: false
  alias Papatron3000.Repo
  alias Papatron3000.Users.{Role, Session, User}

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

  @doc """
  Create a session for the given user.
  """
  def create_session(%User{} = user) do
    session =
      %Session{}
      |> Session.changeset(%{user_id: user.id})
      |> Repo.insert()

    {:ok, session}
  end

  def create_session(nil) do
    {:error, "No such user"}
  end

  @doc """
  Get session.
  """
  def current_session() do
    from(s in Session)
    |> Repo.one()
  end

  @doc """
  Gets the current user, if there is an active session.
  """
  def current_user() do
    from(
      u in User,
      join: s in Session, on: s.user_id == u.id
    )
    |> Repo.one()
    |> case do
      nil ->
        {:error, "No user found."}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Removes the session.
  """
  def destroy_session(%Session{} = session) do
    Repo.delete(session)
  end

  def destroy_session(nil), do: nil

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
