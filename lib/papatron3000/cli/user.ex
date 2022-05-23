defmodule Papatron3000.CLI.User do
  alias Papatron3000.Users
  alias Papatron3000.Users.User

  def dispatch_command(["create"], switches) do
    switches
    |> OptionParser.parse(strict: [email: :string, first_name: :string, last_name: :string])
    |> then(fn {_, options, _} -> options end)
    |> create()
  end

  def dispatch_command(["whoami"], _switches) do
    with {:ok, user} <- Users.current_user() do
      IO.puts """
      CURRENT USER:
        #{user.first_name} #{user.last_name}
        Email: #{user.email}
        Balance: #{user.balance}

      """

    else
      _ ->
        IO.puts """
        There is no active session. Use "papatron3000 user login" to create
        a session or use "papatron3000 user create" to first create a user.

        """
    end
  end

  def dispatch_command(["login"], switches) do
    switches
    |> OptionParser.parse(strict: [email: :string])
    |> then(fn {_, options, _} -> options end)
    |> login()
  end

  def dispatch_command(["logout"], _switches) do
    Users.current_session()
    |> Users.destroy_session()
    IO.puts "Logged out."
  end

  def dispatch_command(_options, _switches) do
    IO.puts "Unknown user sub-command."
  end

  defp create(options) do
    options
    |> Enum.into(%{})
    |> Users.create_user()
    |> case do
      {:ok, %User{email: email}} ->
        IO.puts "User successfully created! Use 'papatron3000 user login #{email}' to login with this user."

      {:error, changeset} ->
        IO.puts "User creation failed!"
        IO.inspect(changeset.errors)
    end
  end

  defp login([{:email, email}]) do
    Users.get_user_by_email(email)
    |> Users.create_session()
    |> case do
      {:ok, _session} ->
        IO.puts "Successfully logged in!"

      {:error, error} ->
        IO.puts "Error: #{error}"
    end
  end

  defp login([]) do
    IO.puts "Must provide a valid email to login."
  end
end
