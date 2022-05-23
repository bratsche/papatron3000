defmodule Papatron3000.CLI.Help do
  def print_help(["user"]) do
    IO.puts """
    Manage users.

    USAGE
      papatron3000 user <subcommand> [flags]

    SUB-COMMANDS
      create      Create a new user
      whoami      Prints info about the current user
      login       Login to the specified user
      logout      Logout
    """
  end

  def print_help(["visit"]) do
    IO.puts """
    Manage visits.

    USAGE
      papatron3000 visit <subcommand> [flags]

    SUB-COMMANDS
      request     Requests a new visit for a member
      list        Lists potential visits a pal can fulfill
      fulfill     Fulfills the specified visit.
    """
  end

  def print_help([unknown_subcommand]) do
    IO.puts """
    Unknown sub-command '#{unknown_subcommand}' to get help with.
    """
  end

  def print_help([]) do
    IO.puts """
    papatron3000

    USAGE
      papatron3000 <command> <subcommand> [flags]

    COMMANDS
      user     Manage users and sessions
      role     Manage roles for the current user
      visit    Manage visits
      help     Help about any command
    """
  end
end
