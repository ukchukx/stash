defmodule Stash.MovieTest do
  alias Stash.{Movies, DataCase}
  alias Stash.Projections.Movie

  use DataCase

  @moduletag models: :movie
  @moduletag :movie

  describe "a movie" do
    test "can be created" do
      assert {:ok, %Movie{id: movie_id}} = fixture(:movie)
      assert {:ok, _} = Movies.movie_by_id(movie_id)
    end

    test "can be updated" do
      assert {:ok, %Movie{id: movie_id} = movie} = fixture(:movie)

      params = build_movie_params() |> Map.take([:tags])

      assert {:ok, %Movie{} = updated_movie} = Movies.update_movie(movie, params)

      # Unchanged
      assert movie.id == updated_movie.id
      assert movie.title == updated_movie.title
      assert movie.imdb_id == updated_movie.imdb_id
      assert movie.thumbnail == updated_movie.thumbnail
      assert movie.trailer == updated_movie.trailer
      # Changed
      assert updated_movie.tags == params.tags
    end

    test "can be deleted" do
      assert {:ok, %Movie{id: movie_id} = movie} = fixture(:movie)
      assert :ok = Movies.delete_movie(movie)
      assert {:error, :not_found} = Movies.movie_by_id(movie_id)
    end
  end
end
