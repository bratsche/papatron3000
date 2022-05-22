defmodule Papatron3000.Fixtures do
  alias Papatron3000.Users

  def user_fixture(attrs \\ %{}) do
    email = "somebody#{System.unique_integer()}@somewhere.com"

    attrs
    |> Enum.into(%{first_name: "Bruce", last_name: "Wayne", email: email})
    |> Users.create_user()
  end

  def pal_user_fixture(attrs \\ %{}) do
    {:ok, user} = user_fixture(attrs)
    Users.add_role(user, :pal)

    {:ok, user}
  end

  def member_user_fixture(attrs \\ %{}) do
    {:ok, user} = user_fixture(attrs)
    Users.add_role(user, :member)

    {:ok, user}
  end
end
