defmodule Stash.Commands.DeleteMovie do
  defstruct [:movie_id, :list_id, :user_id]
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.DeleteMovie do
  alias Stash.Validators.Uuid

  def validate(command = %{movie_id: movie_id}) do
    movie_id
    |> validate_movie_id()
    |> Kernel.++(validate_user_id(command.user_id))
    |> Kernel.++(validate_list_id(command.list_id))
    |> case do
      [] -> :ok
      err_list -> {:error, err_list}
    end
  end

  defp validate_movie_id(movie_id) do
    case Uuid.validate(movie_id) do
      :ok -> []
      {:error, err} -> [{:movie_id, err}]
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
