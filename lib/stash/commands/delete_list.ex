defmodule Stash.Commands.DeleteList do
  defstruct [:list_id, :user_id]
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.DeleteList do
  alias Stash.Validators.Uuid

  def validate(command = %{list_id: list_id}) do
    list_id
    |> validate_list_id()
    |> Kernel.++(validate_user_id(command.user_id))
    |> case do
      [] -> :ok
      err_list -> {:error, err_list}
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
