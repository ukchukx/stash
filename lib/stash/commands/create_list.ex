defmodule Stash.Commands.CreateList do
  defstruct [:user_id, :list_id, :name, :type]

  def assign_id(%__MODULE__{} = command, id), do: %__MODULE__{command | list_id: id}
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.CreateList do
  alias Stash.Validators.{StringValidator, Uuid}

  def validate(%{user_id: user_id, list_id: list_id} = command) do
    user_id
    |> validate_user_id
    |> Kernel.++(validate_list_id(list_id))
    |> Kernel.++(validate_name(command.name))
    |> Kernel.++(validate_type(command.type))
    |> case do
      [] -> :ok
      err_list -> {:error, err_list}
    end
  end

  defp validate_user_id(user_id) do
    case Uuid.validate(user_id) do
      :ok -> []
      {:error, err} -> [{:user_id, err}]
    end
  end

  defp validate_list_id(list_id) do
    case Uuid.validate(list_id) do
      :ok -> []
      {:error, err} -> [{:list_id, err}]
    end
  end

  defp validate_name(""), do: [{:name, "is empty"}]

  defp validate_name(nil), do: [{:name, "is not a string"}]

  defp validate_name(name) do
    case StringValidator.validate(name) do
      :ok -> []
      {:error, err} -> [{:name, err}]
    end
  end

  defp validate_type(x) when x in ~w(book movie), do: []

  defp validate_type(_), do: [{:type, "is not a supported list type"}]
end
