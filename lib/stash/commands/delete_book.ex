defmodule Stash.Commands.DeleteBook do
  defstruct [:book_id, :list_id, :user_id]
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.DeleteBook do
  alias Stash.Validators.Uuid

  def validate(command = %{book_id: book_id}) do
    book_id
    |> validate_book_id()
    |> Kernel.++(validate_user_id(command.user_id))
    |> Kernel.++(validate_list_id(command.list_id))
    |> case do
      [] -> :ok
      err_list -> {:error, err_list}
    end
  end

  defp validate_book_id(book_id) do
    case Uuid.validate(book_id) do
      :ok -> []
      {:error, err} -> [{:book_id, err}]
    end
  end

  defp validate_list_id(list_id) do
    case Uuid.validate(list_id) do
      :ok -> []
      {:error, err} -> [{:list_id, err}]
    end
  end

  defp validate_user_id(user_id) do
    case Uuid.validate(user_id) do
      :ok -> []
      {:error, err} -> [{:user_id, err}]
    end
  end
end
