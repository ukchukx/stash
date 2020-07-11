defmodule Stash.CommandedSupervisor do
  alias Stash.{Projectors, EventHandlers}

  use Supervisor

  def start_link(_), do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  def init(_arg) do
    Supervisor.init([
      Projectors.User,
      Projectors.Book,
      EventHandlers.Telemetry
    ], strategy: :one_for_one)
  end
end
