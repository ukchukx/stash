defmodule Stash.Storage do
  alias Stash.Repo
  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    :ok = Application.stop(:stash)
    :ok = Application.stop(:commanded)
    reset_event_store()
    reset_read_store()
    {:ok, _} = Application.ensure_all_started(:stash)
    :ok
  end

  defp reset_event_store do
    Stash.EventStore.config
    |> EventStore.Config.parse
    |> EventStore.Config.default_postgrex_opts
    |> Postgrex.start_link
    |> elem(1)
    |> EventStore.Storage.Initializer.reset!
  end

  defp reset_read_store do
    :stash
    |> Application.get_env(Repo)
    |> Postgrex.start_link
    |> elem(1)
    |> Postgrex.query!(truncate_read_tables_query(), [])
  end

  defp truncate_read_tables_query do
    Application.get_env(:stash, Repo)[:truncate_read_tables_query]
  end
end
