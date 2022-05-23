defmodule Papatron3000.CLI do
  def main(args) do
    args
    |> OptionParser.parse(strict: [user: :string, visit: :string, help: :string, email: :string, first_name: :string, last_name: :string, date: :string, minutes: :integer, id: :integer])
    |> then(fn {switches, commands, _} -> {commands, switches} end)
    |> handle_options()
  end

  defp handle_options({["help" | options], _switches}) do
    Papatron3000.CLI.Help.print_help(options)
  end

  defp handle_options({["user" | options], switches}) do
    Papatron3000.CLI.User.dispatch_command(options, switches)
  end

  defp handle_options({["role" | options], switches}) do
    Papatron3000.CLI.Role.dispatch_command(options, switches)
  end

  defp handle_options({["visit" | options], switches}) do
    Papatron3000.CLI.Visit.dispatch_command(options, switches)
  end

  defp handle_options({_options, _switches}) do
    Papatron3000.CLI.Help.print_help([])
  end
end
