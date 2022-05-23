defmodule Papatron3000.CLI.Visit do
  alias Papatron3000.{Users, Visits}

  def dispatch_command(["request"], switches) do
    switches
    |> OptionParser.parse(strict: [date: :string, minutes: :integer, task: :string, id: :integer])
    |> then(fn {_, options, _} -> options end)
    |> request()
  end

  def dispatch_command(["list"], _switches) do
    with {:ok, user} <- Users.current_user() do
      case Users.has_role?(user, :pal) do
        false ->
          IO.puts "You are not a pal."

        true ->
          Visits.get_potential_visits_for_pal(user)
          |> print_listing()
      end
    else
      {:error, error} ->
        IO.puts "Error: #{error}"
    end
  end

  def dispatch_command(["fulfill"], switches) do
    fulfill(switches)
  end

  defp print_listing([]) do
    IO.puts "There are no visits you can fulfill at this time."
  end

  defp print_listing(visits) do
    visits
    |> Enum.each(fn x ->
      IO.puts """

      --> ID: #{x.id}, Date: #{Date.to_string(x.requested_date)}, Minutes: #{x.minutes}

      """
    end)
  end

  defp request(options) do
    with {:ok, user} <- Users.current_user() do
      request_params =
        Enum.into(options, %{})

      Visits.request_visit(user, request_params)
      |> case do
        {:ok, _} ->
          IO.puts "Visit requested."

        {:error, _} ->
          IO.puts "Failed to request visit."
          IO.puts "Please specify a date with '--date' and minutes with '--minutes'."
      end
    else
      {:error, error} ->
        IO.puts "Error: #{error}"
    end
  end

  defp fulfill([id: id]) do
    with {:ok, user} <- Users.current_user(),
         {:ok, visit} <- Visits.get_visit(id)
    do
      Visits.fulfill_visit(user, visit)
      |> case do
        {:ok, _} ->
          IO.puts "Visit has been fulfilled. Your balance has been updated."

        {:error, error} ->
          IO.puts "Error: #{error}"
      end
    end
  end

  defp fulfill(_) do
    IO.puts "You must specify the id of the visit."
  end
end
