defmodule Stash.Commands.UpdateBook do
  defstruct [:book_id, :tags, :notes]

  def assign_book(%__MODULE__{} = command, %{id: id} = _book) do
    %__MODULE__{command | book_id: id}
  end
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.UpdateBook do
  alias Stash.Validators.{StringValidator, Uuid, ListValidator}

  def validate(%{book_id: book_id} = command) do
    book_id
    |> validate_book_id
    |> Kernel.++(validate_tags(command.tags))
    |> Kernel.++(validate_notes(command.notes))
    |> case do
      []       -> :ok
      err_list -> {:error, err_list}
    end
  end

  defp validate_book_id(book_id) do
    case Uuid.validate(book_id) do
      :ok           -> []
      {:error, err} -> [{:book_id, err}]
    end
  end

  defp validate_tags([]), do: []

  defp validate_tags(nil), do: []

  defp validate_tags(tags) do
    case ListValidator.validate_list_of_string(tags) do
      :ok           -> []
      {:error, err} -> [{:tags, err}]
    end
  end

  defp validate_notes(""), do: []

  defp validate_notes(nil), do: []

  defp validate_notes(notes) do
    case StringValidator.validate(notes) do
      :ok           -> []
      {:error, err} -> [{:notes, err}]
    end
  end
end
