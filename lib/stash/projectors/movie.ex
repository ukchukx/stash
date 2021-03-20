defmodule Stash.Projectors.Movie do
  use Commanded.Projections.Ecto,
    name: "Projector.Movie",
    application: Stash.CommandedApp,
    consistency: :strong

  alias Stash.Events.{
    MovieCreated,
    MovieDeleted,
    MovieTagsChanged
  }

  alias Stash.Movies
  alias Stash.Projections.{Movie, UserMovie}
  alias Stash.Queries.ById
  alias Stash.Core.Utils

  project(%MovieCreated{movie_id: id, imdb_id: imdb_id} = event, fn multi ->
    user_movie_changes = %UserMovie{
      id: id,
      user_id: event.user_id,
      list_id: event.list_id,
      tags: event.tags,
      title: event.title,
      imdb_id: event.imdb_id,
      thumbnail: event.thumbnail
    }

    case Movies.movie_by_imdb_id(imdb_id) do
      {:ok, _movie} ->
        Ecto.Multi.insert(multi, :user_movie, user_movie_changes)

      {:error, _} ->
        movie_changes = %Movie{
          id: Utils.new_id(),
          title: event.title,
          imdb_id: event.imdb_id,
          thumbnail: event.thumbnail
        }

        multi
        |> Ecto.Multi.insert(:user_movie, user_movie_changes)
        |> Ecto.Multi.insert(:movie, movie_changes)
    end
  end)

  project(%MovieTagsChanged{movie_id: id, tags: tags}, fn multi ->
    update_movie(multi, id, tags: tags)
  end)

  project(%MovieDeleted{movie_id: id}, fn multi ->
    Ecto.Multi.delete_all(multi, :movie, ById.one(UserMovie, id))
  end)

  defp update_movie(multi, id, changes) do
    Ecto.Multi.update_all(multi, :movie, ById.one(UserMovie, id), set: changes)
  end
end
