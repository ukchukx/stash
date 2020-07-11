defmodule Stash.Projectors.Movie do
  use Commanded.Projections.Ecto,
    name: "Projector.Movie",
    application: Stash.CommandedApp,
    consistency: :strong

  alias Stash.Events.{
    MovieDeleted,
    MovieTagsChanged,
    MovieCreated
  }
  alias Stash.Projections.Movie
  alias Stash.Queries.ById
  alias Stash.Support.Utils

  project %MovieCreated{movie_id: id} = event, fn multi ->
    changes =
      event
      |> Utils.to_map
      |> Map.drop([:movie_id])
      |> Map.put(:id, id)

    Ecto.Multi.insert(multi, :movie, struct(Movie, changes))
  end

  project %MovieTagsChanged{movie_id: id, tags: tags}, fn multi ->
    update_movie(multi, id, tags: tags)
  end

  project %MovieDeleted{movie_id: id}, fn multi ->
    Ecto.Multi.delete_all(multi, :movie, ById.one(Movie, id))
  end

  defp update_movie(multi, id, changes) do
    Ecto.Multi.update_all(multi, :movie, ById.one(Movie, id), set: changes)
  end
end
