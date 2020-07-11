defmodule Stash.Commands.DeleteMovie do
  defstruct [:movie_id]
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.DeleteMovie do
  alias Stash.Validators.Uuid

  def validate(%{movie_id: movie_id} = _command) do
    movie_id
    |> Uuid.validate
    |> case do
      :ok           -> :ok
      {:error, err} -> [{:movie_id, err}]
    end
  end
end
