defmodule Stash.Commands.UpdateMovie do
  defstruct [:movie_id, :tags]

  def assign_movie(%__MODULE__{} = command, %{id: id} = _movie) do
    %__MODULE__{command | movie_id: id}
  end
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.UpdateMovie do
  alias Stash.Validators.{Uuid, ListValidator}

  def validate(%{movie_id: movie_id} = command) do
    movie_id
    |> validate_movie_id
    |> Kernel.++(validate_tags(command.tags))
    |> case do
      []       -> :ok
      err_list -> {:error, err_list}
    end
  end

  defp validate_movie_id(movie_id) do
    case Uuid.validate(movie_id) do
      :ok           -> []
      {:error, err} -> [{:movie_id, err}]
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
end
