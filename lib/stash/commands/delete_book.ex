defmodule Stash.Commands.DeleteBook do
  defstruct [:book_id]
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.DeleteBook do
  alias Stash.Validators.Uuid

  def validate(%{book_id: book_id} = _command) do
    book_id
    |> Uuid.validate
    |> case do
      :ok           -> :ok
      {:error, err} -> [{:book_id, err}]
    end
  end
end
