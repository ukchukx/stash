defmodule Stash.Commands.DisableUser do
  defstruct [:user_id]
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.DisableUser do
  alias Stash.Validators.Uuid

  def validate(%{user_id: user_id} = _command) do
    user_id
    |> Uuid.validate()
    |> case do
      :ok -> :ok
      {:error, err} -> [{:user_id, err}]
    end
  end
end
