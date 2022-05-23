defmodule Papatron3000.VisitsTest do
  use Papatron3000.DataCase
  import Papatron3000.Fixtures
  alias Papatron3000.Users
  alias Papatron3000.Visits
  alias Papatron3000.Visits.Visit

  describe "requesting a visit" do
    test "succeeds when the user is a member" do
      {:ok, user} = member_user_fixture()

      user = Users.get_user_by_email(user.email)

      assert {:ok, %Visit{}} = Visits.request_visit(user, %{requested_date: ~D[2022-06-01], minutes: 30})
    end

    test "fails when the user is not a member" do
      {:ok, user} = user_fixture()

      assert {:error, "Not a member"} = Visits.request_visit(user, %{requested_date: ~D[2022-06-01], minutes: 30})
    end

    test "fails when member doesn't have enough balance for the requested amount of time" do
      {:ok, user} = member_user_fixture(%{balance: 20})

      assert {:error, "Insufficient balance"} = Visits.request_visit(user, %{requested_date: ~D[2022-12-01], minutes: 30})
    end
  end

  describe "listing potential upcoming visits for a pal" do
    test "users without the pal role cannot list upcoming visits" do
      {:ok, user} = user_fixture()
      {:ok, member} = member_user_fixture()
      {:ok, _visit} = Visits.request_visit(member, %{requested_date: ~D[2022-12-01], minutes: 30})

      assert {:error, "Not a pal"} = Visits.get_potential_visits_for_pal(user)
    end

    test "pals can view upcoming visits" do
      {:ok, pal} = pal_user_fixture()
      {:ok, member} = member_user_fixture()
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
      {:ok, member} = member_user_fixture()
      {:ok, pal} = pal_user_fixture()

      {:ok, _visit} = Visits.request_visit(member, %{requested_date: ~D[2020-12-01], minutes: 30})

      assert Visits.get_potential_visits_for_pal(pal) == []
    end

    test "fulfilling a visit will create a transaction and alter member's and pal's balances" do
      {:ok, member} = member_user_fixture()
      {:ok, pal} = pal_user_fixture()

      {:ok, visit} = Visits.request_visit(member, %{requested_date: ~D[2022-12-01], minutes: 30})
      visit = visit |> Repo.preload(:user)

      # Check that the pal has the visit in their list
      assert Visits.get_potential_visits_for_pal(pal) != []

      refute Visits.is_fulfilled?(visit)

      {:ok, %{member: member, pal: pal, transaction: transaction}} = Visits.fulfill_visit(pal, visit)
      assert transaction != nil
      assert member.balance == 30
      assert pal.balance == 85

      assert Visits.is_fulfilled?(visit)

      # Check that the visit no longer shows up in the pal's list since it's fulfilled.
      assert Visits.get_potential_visits_for_pal(pal) == []
    end
  end

  test "fulfilling a visit should not succeed if the member has insufficient balance" do
    {:ok, member} = member_user_fixture()
    {:ok, pal} = pal_user_fixture()

    {:ok, %Visit{} = visit1} = Visits.request_visit(member, %{requested_date: ~D[2022-12-01], minutes: 45})
    {:ok, %Visit{} = visit2} = Visits.request_visit(member, %{requested_date: ~D[2022-12-01], minutes: 45})

    assert {:ok, %{member: _member, pal: pal, transaction: _transaction}} = Visits.fulfill_visit(pal, visit1)

    assert {:error, "Insufficient balance"} = Visits.fulfill_visit(pal, visit2)
  end
end
