defmodule Stash.MovieTest do
  alias Stash.{Movies, DataCase}
  alias Stash.Projections.UserMovie, as: Movie

  use DataCase

  @moduletag models: :movie
  @moduletag :movie

  describe "a movie" do
    test "can be created" do
      user = %{lists: [list]} = create_user_having_a_list("movie")
      assert {:ok, %Movie{id: movie_id}} = create_movie(user, list_id: list["id"])
      assert {:ok, %Movie{}} = Movies.movie_by_id(movie_id)
    end

    test "can be updated" do
      user = %{lists: [list]} = create_user_having_a_list("movie")
      {:ok, %Movie{} = movie} = create_movie(user, list_id: list["id"])
      params = build_movie_params() |> Map.take([:tags])
      assert {:ok, %Movie{} = updated_movie} = Movies.update_movie(movie, params)

      # Unchanged
      assert movie.id == updated_movie.id
      assert movie.title == updated_movie.title
      assert movie.imdb_id == updated_movie.imdb_id
      assert movie.thumbnail == updated_movie.thumbnail
      # Changed
      assert updated_movie.tags == params.tags
    end

    test "can be deleted" do
      user = %{lists: [list], id: user_id} = create_user_having_a_list("movie")
      {:ok, %Movie{} = movie} = create_movie(user, list_id: list["id"])
      assert :ok = Movies.delete_movie(movie)
      assert {:error, :not_found} = Movies.movie_by_user_and_id(user_id, movie.id)
    end
  end
end
