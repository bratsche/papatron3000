defmodule Papatron3000.CLI.Visit do
  alias Papatron3000.{Users, Visits}

  def dispatch_command(["request"], switches) do
    switches
    |> OptionParser.parse(strict: [date: :string, minutes: :integer, task: :string])
    |> then(fn {_, options, _} -> options end)
    |> request()
  end

  def dispatch_command(["list"], _switches) do
    user = Users.current_user()

    case Users.has_role?(user, :pal) do
      false ->
        IO.puts "You are not a pal."

      true ->
        Visits.get_potential_visits_for_pal(user)
        |> Enum.each(fn x ->
          IO.puts """

          --> ID: #{x.id}, Date: #{Date.to_string(x.requested_date)}, Minutes: #{x.minutes}

          """
        end)
    end
  end

  defp request(options) do
    user = Users.current_user()

    case user do
      nil ->
        IO.puts "You are not logged in."

      user ->
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
    end
  end
end
