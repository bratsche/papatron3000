defmodule Papatron3000.VisitsTest do
  use Papatron3000.DataCase
  import Papatron3000.Fixtures
  alias Papatron3000.Users
  alias Papatron3000.Visits
  alias Papatron3000.Visits.Visit

  describe "requesting a visit" do
    test "succeeds when the user is a member" do
      {:ok, user} = user_fixture()

      Users.add_role(user, :member)
      user = Users.get_user_by_email(user.email)

      assert {:ok, %Visit{}} = Visits.request_visit(user, %{requested_date: ~D[2022-06-01], minutes: 30})
    end

    test "fails when the user is not a member" do
      {:ok, user} = user_fixture()

      assert {:error, "Not a member"} = Visits.request_visit(user, %{requested_date: ~D[2022-06-01], minutes: 30})
    end
  end

  describe "listing potential upcoming visits for a pal" do
    test "users without the pal role cannot list upcoming visits" do
      {:ok, user} = user_fixture()
      {:ok, member} = user_fixture()
      Users.add_role(member, :member)
      {:ok, _visit} = Visits.request_visit(member, %{requested_date: ~D[2022-12-01], minutes: 30})

      assert {:error, "Not a pal"} = Visits.get_potential_visits_for_pal(user)
    end

    test "pals can view upcoming visits" do
      {:ok, pal} = user_fixture()
      Users.add_role(pal, :pal)

      {:ok, member} = user_fixture()
      Users.add_role(member, :member)

      {:ok, visit} = Visits.request_visit(member, %{requested_date: ~D[2022-12-01], minutes: 30})

      visit_ids =
        Visits.get_potential_visits_for_pal(pal)
        |> Enum.map(fn x -> x.id end)

      assert visit_ids == [visit.id]
    end

    test "pals who are also members will not see upcoming visits they created" do
      {:ok, user} = user_fixture()
      Users.add_role(user, :pal)
      Users.add_role(user, :member)

      {:ok, _visit} = Visits.request_visit(user, %{requested_date: ~D[2022-12-01], minutes: 30})

      assert Visits.get_potential_visits_for_pal(user) == []
    end

    test "unfulfilled visits in the past will not be shown in the list" do
      # TODO
    end
  end
end
