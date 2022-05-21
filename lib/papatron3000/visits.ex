defmodule Papatron3000.Visits do
  import Ecto.Query, warn: false
  alias Papatron3000.Repo
  alias Papatron3000.Users
  alias Papatron3000.Users.User
  alias Papatron3000.Visits.Visit

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
end
