defmodule Stash.Aggregates.MovieTest do
  alias Stash.Events.{MovieCreated, MovieDeleted, MovieTagsChanged}
  alias Stash.Commands.{DeleteMovie, UpdateMovie}
  alias Stash.Support.Utils
  alias Stash.Aggregates.Movie
  alias Stash.AggregateCase

  use AggregateCase, aggregate: Movie

  @moduletag aggregates: :movie
  @moduletag :movie

  describe "CreateMovie" do
    test "should emit MovieCreated" do
      command = build(:create_movie_command)

      assert_events(command, [struct(MovieCreated, Utils.to_map(command))])
    end
  end

  describe "DeleteMovie" do
    test "should emit MovieDeleted" do
      %{id: movie_id} = aggregate = build(:movie_aggregate)

      assert_events(
        aggregate,
        %DeleteMovie{movie_id: movie_id},
        [%MovieDeleted{movie_id: movie_id}]
      )
    end
  end

  describe "UpdateMovie" do
    test "should emit MovieTagsChanged" do
      %{id: id} = aggregate = build(:movie_aggregate)
      params = build(:movie)

      assert_events(
        aggregate,
        struct(UpdateMovie, params),
        [%MovieTagsChanged{movie_id: id, tags: params.tags}]
      )
    end
  end
end
