defmodule Stash.Commands do
  alias Stash.CommandedApp

  def dispatch(command, opts \\ []) do
    CommandedApp.dispatch(
      command,
      opts ++ [returning: :aggregate_state, consistency: Keyword.get(opts, :consistency, :strong)]
    )
  end
end
