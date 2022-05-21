defmodule Papatron3000.UsersTest do
  use Papatron3000.DataCase
  alias Papatron3000.Users
  alias Papatron3000.Users.User

  def user_fixture(attrs \\ %{}) do
    email = "somebody#{System.unique_integer()}@somewhere.com"

    attrs
    |> Enum.into(%{first_name: "Bruce", last_name: "Wayne", email: email})
    |> Users.create_user()
  end

  describe "getting a user by email address" do
    test "fetches a user if it exists" do
      {:ok, %User{id: id, email: email}} = user_fixture()

      assert %User{id: ^id} = Users.get_user_by_email(email)
    end

    test "does not get a user if no user matches the email" do
      refute Users.get_user_by_email("bruce@thebatcave.com")
    end
  end

  describe "users have a default balance" do
    test "that the default balance is set" do
      {:ok, user} = user_fixture()
      assert user.balance == 60
    end
  end

  describe "user roles" do
    test "adding a valid role" do
      {:ok, user} = user_fixture()

      refute Users.has_role?(user, :member)

      Users.add_role(user, :member)

      assert Users.has_role?(user, :member)
    end

    test "adding the same role multple times fails" do
      {:ok, user} = user_fixture()

      refute Users.has_role?(user, :pal)
      Users.add_role(user, :pal)
      assert Users.has_role?(user, :pal)

      assert {:error, "This role is already set."} = Users.add_role(user, :pal)

      assert Users.has_role?(user, :pal)
    end

    test "adding an invalid role raises" do
      {:ok, user} = user_fixture()

      assert_raise Ecto.Query.CastError, fn ->
        Users.add_role(user, :foobar)
      end
    end

    test "querying for an invalid role raises" do
      {:ok, user} = user_fixture()

      assert_raise Ecto.Query.CastError, fn ->
        Users.has_role?(user, :foobar)
      end
    end
  end
end
