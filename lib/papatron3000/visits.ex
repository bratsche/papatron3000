defmodule Papatron3000.Visits do
  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Papatron3000.Repo
  alias Papatron3000.Users
  alias Papatron3000.Users.User
  alias Papatron3000.Visits.{Transaction, Visit}

  @doc """
  This is used to create visit requests for members. Users must have
  the `:member` role in order to request visits, and their account balance
  must be equal or greater than the number of minutes they are requesting
  for the visit.
  """
  def request_visit(%User{} = member, attrs) do
    case Users.has_role?(member, :member) do
      true ->
        do_request_visit(member, attrs)

      false ->
        {:error, "Not a member"}
    end
  end

  defp do_request_visit(%User{balance: balance}, %{minutes: minutes}) when minutes > balance do
    {:error, "Insufficient balance"}
  end

  defp do_request_visit(%User{} = member, attrs) do
    Ecto.build_assoc(member, :visits)
    |> Visit.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  This is used by pals to look for visits to do. Users must have the
  `:pal` role in order to list visits here. This will also not list
  visits in the past.
  """
  def get_potential_visits_for_pal(%User{} = pal) do
    case Users.has_role?(pal, :pal) do
      true ->
        today = Date.utc_today()

        from(
          v in Visit,
          where: v.user_id != ^pal.id,
          where: v.requested_date >= ^today
        )
        |> Repo.all()

      false ->
        {:error, "Not a pal"}
    end
  end

  @doc """
  When a pal performs a visit, we create a transaction log for the visit.
  We also transfer the minutes of the member's balance over to the pal's
  balance, minus 15% (rounding down--we don't store fractions of minutes).
  """
  def perform_visit(%User{} = pal, %Visit{minutes: minutes} = visit) do
    case Users.has_role?(pal, :pal) do
      true ->
        transaction_changeset =
          Ecto.build_assoc(visit, :transaction)
          |> Transaction.changeset(%{member_id: visit.user_id, pal_id: pal.id})

        Multi.new()
        |> Multi.insert(:transaction, transaction_changeset)
        |> Multi.update(:member, User.changeset(visit.user, %{balance: visit.user.balance - minutes}))
        |> Multi.update(:pal, User.changeset(pal, %{balance: pal.balance + trunc(minutes * 0.85)}))
        |> Repo.transaction()

      false ->
        {:error, "Not a pal"}
    end
  end
end
