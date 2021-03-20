defmodule Stash.Commands.UpdateList do
  defstruct [:list_id, :user_id, :name]

  def assign_list(%__MODULE__{} = command, _book = %{id: id}) do
    %__MODULE__{command | list_id: id}
  end
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.UpdateList do
  alias Stash.Validators.{StringValidator, Uuid}

  def validate(command = %{list_id: list_id}) do
    list_id
    |> validate_list_id
    |> Kernel.++(validate_user_id(command.user_id))
    |> Kernel.++(validate_name(command.name))
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

  defp validate_name(""), do: [{:name, "is empty"}]

  defp validate_name(nil), do: []

  defp validate_name(name) do
    case StringValidator.validate(name) do
      :ok -> []
      {:error, err} -> [{:name, err}]
    end
  end
end
