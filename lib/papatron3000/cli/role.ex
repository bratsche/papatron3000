defmodule Papatron3000.CLI.Role do
  alias Papatron3000.Users

  def dispatch_command(["add" | []], _switches) do
    IO.puts "Error: No role specified."
  end

  def dispatch_command(["add" | options], _switches) do
    options
    |> add()
  end

  defp add([role]) when role in ["member", "pal"] do
    user = Users.current_user()

    case user do
      nil ->
        IO.puts "You are not logged in."

      user ->
        Users.add_role(user, role)
        |> case do
          {:ok, _} ->
            IO.puts "Role added."

          {:error, error} ->
            IO.puts(error)
        end
    end
  end

  defp add(role) do
    IO.puts "Invalid role '#{role}'."
  end
end
