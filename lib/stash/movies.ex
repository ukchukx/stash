defmodule Stash.Movies do
  alias Stash.Commands.{CreateMovie, DeleteMovie, UpdateMovie}
  alias Stash.Queries.{ById, Movies}
  alias Stash.{Commands, Queries}
  alias Stash.Projections.Movie

  def build_create_movie_command(%{} = attrs, %{user: %{id: id}} = _context) do
    attrs =
      attrs
      |> Map.put(:user_id, id)
      |> Map.put(:movie_id, Ecto.UUID.generate())

    struct(CreateMovie, attrs)
  end

  def build_update_movie_command(%{id: id} = _movie, %{} = attrs) do
    struct(UpdateMovie, Map.put(attrs, :movie_id, id))
  end

  def create_movie(%{} = attrs, %{user: %{}} = context) do
    attrs
    |> build_create_movie_command(context)
    |> Commands.dispatch
    |> case do
      {:ok, %{id: id}} -> movie_by_id(id)
      response -> response
    end
  end

  def update_movie(%{id: id} = _movie, attrs = %{}) do
    with {:ok, %{} = movie} <- movie_by_id(id),
         {:ok, %{id: id}} <- movie |> build_update_movie_command(attrs) |> Commands.dispatch do
      movie_by_id(id)
    else
      reply	-> reply
    end
  end

  def delete_movie(%{id: id} = _movie) do
    with {:ok, _} <- movie_by_id(id),
         {:ok, _state}	<- DeleteMovie |> struct(%{movie_id: id}) |> Commands.dispatch do
      :ok
    else
      res -> res
    end
  end

  def movie_by_id(id) when is_binary(id), do: Movie |> ById.one(id) |> Queries.fetch_one

  def movie_by_user_and_imdb_id(user_id, imdb_id) do
    user_id
    |> Movies.by_user_and_imdb_id(imdb_id)
    |> Queries.fetch_one
  end

  def movies_for_user(user_id), do: user_id |> Movies.for_user |> Queries.fetch_all

end
