defmodule Stash.Movies do
  alias Stash.Commands.{CreateMovie, DeleteMovie, UpdateMovie}
  alias Stash.Queries.{ById, Movies}
  alias Stash.{Commands, Queries}
  alias Stash.Projections.UserMovie
  alias Stash.Core.Utils

  def build_create_movie_command(%{} = attrs, %{user: %{id: id}} = _context) do
    attrs =
      attrs
      |> Map.put(:user_id, id)
      |> Map.put(:movie_id, Utils.new_id())

    struct(CreateMovie, attrs)
  end

  def build_update_movie_command(%{id: id} = movie, %{} = attrs) do
    attrs =
      attrs
      |> Map.put(:movie_id, id)
      |> Map.put(:list_id, movie.list_id)
      |> Map.put(:user_id, movie.user_id)

    struct(UpdateMovie, attrs)
  end

  def create_movie(%{} = attrs, %{user: %{}} = context) do
    command = %{movie_id: id} = build_create_movie_command(attrs, context)

    command
    |> Commands.dispatch()
    |> case do
      {:ok, _state} -> movie_by_id(id)
      response -> response
    end
  end

  def update_movie(%{id: id, user_id: user_id} = _movie, attrs = %{}) do
    with {:ok, %{list_id: list_id} = movie} <- movie_by_id(id),
         attrs =
           attrs
           |> Map.put(:list_id, list_id)
           |> Map.put(:user_id, user_id)
           |> Map.put(:movie_id, id),
         {:ok, _state} <- movie |> build_update_movie_command(attrs) |> Commands.dispatch() do
      movie_by_id(id)
    else
      reply -> reply
    end
  end

  def delete_movie(%{id: id, user_id: user_id} = _movie) do
    with {:ok, %{list_id: list_id}} <- movie_by_id(id),
         attrs = %{movie_id: id, user_id: user_id, list_id: list_id},
         {:ok, _state} <- DeleteMovie |> struct(attrs) |> Commands.dispatch() do
      :ok
    else
      res -> res
    end
  end

  def movie_by_id(id), do: UserMovie |> ById.one(id) |> Queries.fetch_one()

  def movie_by_imdb_id(imdb_id) do
    imdb_id
    |> Movies.by_imdb_id()
    |> Queries.fetch_one()
  end

  def movie_by_user_and_id(user_id, movie_id) do
    user_id |> Movies.by_user_and_id(movie_id) |> Queries.fetch_one()
  end

  def movies_by_user_and_list(user_id, list_id) do
    user_id |> Movies.by_user_and_list(list_id) |> Queries.fetch_all()
  end
end
