defmodule Stash.Commands.CreateMovie do
  defstruct [:user_id, :movie_id, :list_id, :imdb_id, :title, :thumbnail, tags: []]

  def assign_id(%__MODULE__{} = command, id), do: %__MODULE__{command | movie_id: id}
end

defimpl Stash.Protocol.ValidCommand, for: Stash.Commands.CreateMovie do
  alias Stash.Validators.{ListValidator, StringValidator, Uuid, URIValidator}

  def validate(%{user_id: user_id, movie_id: movie_id} = command) do
    user_id
    |> validate_user_id
    |> Kernel.++(validate_list_id(command.list_id))
    |> Kernel.++(validate_movie_id(movie_id))
    |> Kernel.++(validate_thumbnail(command.thumbnail))
    |> Kernel.++(validate_tags(command.tags))
    |> Kernel.++(validate_imdb_id(command.imdb_id))
    |> Kernel.++(validate_title(command.title))
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

  defp validate_tags([]), do: []

  defp validate_tags(nil), do: [{:tags, "is not a list"}]

  defp validate_tags(tags) do
    case ListValidator.validate_list_of_string(tags) do
      :ok -> []
      {:error, err} -> [{:tags, err}]
    end
  end

  defp validate_title(""), do: [{:title, "is empty"}]

  defp validate_title(nil), do: [{:title, "is not a string"}]

  defp validate_title(title) do
    case StringValidator.validate(title) do
      :ok -> []
      {:error, err} -> [{:title, err}]
    end
  end

  defp validate_imdb_id(""), do: [{:imdb_id, "is empty"}]

  defp validate_imdb_id(nil), do: [{:imdb_id, "is not a string"}]

  defp validate_imdb_id(imdb_id) do
    case StringValidator.validate(imdb_id) do
      :ok -> []
      {:error, err} -> [{:imdb_id, err}]
    end
  end

  defp validate_thumbnail(nil), do: []

  defp validate_thumbnail(thumbnail) do
    case URIValidator.validate(thumbnail) do
      :ok -> []
      {:error, err} -> [{:thumbnail, err}]
    end
  end
end
