defmodule Stash.Aggregates.BookTest do
  alias Stash.Events.{BookCreated, BookDeleted, BookNotesChanged, BookTagsChanged}
  alias Stash.Commands.{DeleteBook, UpdateBook}
  alias Stash.Support.Utils
  alias Stash.Aggregates.Book
  alias Stash.AggregateCase

  use AggregateCase, aggregate: Book

  @moduletag aggregates: :book
  @moduletag :book

  describe "CreateBook" do
    test "should emit BookCreated" do
      command = build(:create_book_command)

      assert_events(command, [struct(BookCreated, Utils.to_map(command))])
    end
  end

  describe "DeleteBook" do
    test "should emit BookDeleted" do
      %{id: book_id} = aggregate = build(:book_aggregate)

      assert_events(
        aggregate,
        %DeleteBook{book_id: book_id},
        [%BookDeleted{book_id: book_id}]
      )
    end
  end

  describe "UpdateBook" do
    test "should emit BookNotesChanged and BookTagsChanged" do
      %{id: id} = aggregate = build(:book_aggregate)
      params = :book |> build |> Map.put(:notes, Faker.Lorem.sentence(2..10))

      assert_events(
        aggregate,
        struct(UpdateBook, params),
        [
          %BookTagsChanged{book_id: id, tags: params.tags},
          %BookNotesChanged{book_id: id, notes: params.notes}
        ]
      )
    end
  end
end
