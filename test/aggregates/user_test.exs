defmodule Stash.Aggregates.UserTest do
  alias Stash.Events.{
    BookCreated,
    BookDeleted,
    BookNotesChanged,
    BookTagsChanged,
    ListCreated,
    ListDeleted,
    ListNameChanged,
    MovieCreated,
    MovieDeleted,
    MovieTagsChanged,
    UserCreated,
    UserDisabled,
    UserEnabled,
    UserEmailChanged,
    UserPasswordChanged
  }

  alias Stash.Commands.{
    DeleteBook,
    DeleteList,
    DeleteMovie,
    DisableUser,
    EnableUser,
    UpdateBook,
    UpdateList,
    UpdateMovie,
    UpdateUser
  }

  alias Stash.Support.Utils
  alias Stash.Aggregates.User, as: UserAggregate
  alias Stash.AggregateCase
  alias Stash.Core.{Book, List, Movie, User}
  alias Stash.Factory

  use AggregateCase, aggregate: UserAggregate

  @moduletag aggregates: :user
  @moduletag :user

  describe "CreateUser" do
    test "should emit UserCreated" do
      command = build(:create_user_command)

      assert_events(command, [struct(UserCreated, Utils.to_map(command))])
    end
  end

  describe "DisableUser" do
    test "should emit UserDisabled if user is not disabled" do
      %{id: user_id} = aggregate = build(:user_aggregate)

      assert_events(
        aggregate,
        %DisableUser{user_id: user_id},
        [%UserDisabled{user_id: user_id}]
      )
    end

    test "should not emit any event if user is disabled" do
      %{id: user_id, record: user} = aggregate = build(:user_aggregate)

      assert_events(
        %{aggregate | record: Map.put(user, :active, false)},
        %DisableUser{user_id: user_id},
        []
      )
    end
  end

  describe "EnableUser" do
    test "should emit UserEnabled if user is disabled" do
      %{id: user_id, record: user} = aggregate = build(:user_aggregate)

      assert_events(
        %{aggregate | record: Map.put(user, :active, false)},
        %EnableUser{user_id: user_id},
        [%UserEnabled{user_id: user_id}]
      )
    end

    test "should not emit any event if user is not disabled" do
      %{id: user_id} = aggregate = build(:user_aggregate)

      assert_events(aggregate, %EnableUser{user_id: user_id}, [])
    end
  end

  describe "UpdateUser" do
    test "should emit UserEmailChanged and UserPasswordChanged" do
      %{id: id} = aggregate = build(:user_aggregate)
      params = build_user_params()

      assert_events(
        aggregate,
        struct(UpdateUser, params),
        [
          %UserPasswordChanged{user_id: id, password: params.password},
          %UserEmailChanged{user_id: id, email: params.email}
        ]
      )
    end
  end

  describe "CreateList" do
    test "should emit ListCreated" do
      %{record: user = %{lists: [_list]}} = aggregate = aggregate_with_a_list_and_a_movie()
      command = build(:create_list_command, user_id: user.id)

      assert_events(
        aggregate,
        command,
        [struct(ListCreated, Utils.to_map(command))]
      )
    end
  end

  describe "DeleteList" do
    test "should emit ListDeleted" do
      %{record: user = %{lists: [list]}} = aggregate = aggregate_with_a_list_and_a_movie()

      assert_events(
        aggregate,
        %DeleteList{list_id: list.id, user_id: user.id},
        [%ListDeleted{list_id: list.id, user_id: user.id}]
      )
    end
  end

  describe "UpdateList" do
    test "should emit ListNameChanged" do
      %{record: user = %{lists: [list]}} = aggregate = aggregate_with_a_list_and_a_movie()

      params =
        build_list_params(user_id: user.id, list_id: list.id, type: list.type)
        |> Map.delete(:id)

      assert_events(
        aggregate,
        struct(UpdateList, params),
        [%ListNameChanged{name: params.name, user_id: user.id, list_id: list.id}]
      )
    end
  end

  describe "CreateMovie" do
    test "should emit MovieCreated" do
      %{record: user = %{lists: [list]}} = aggregate = aggregate_with_a_list_and_a_movie()
      command = build(:create_movie_command, user_id: user.id, list_id: list.id)

      assert_events(
        aggregate,
        command,
        [struct(MovieCreated, Utils.to_map(command))]
      )
    end
  end

  describe "DeleteMovie" do
    test "should emit MovieDeleted" do
      %{record: user = %{lists: [list]}} = aggregate = aggregate_with_a_list_and_a_movie()
      %{items: [movie]} = list

      assert_events(
        aggregate,
        %DeleteMovie{movie_id: movie.id, list_id: list.id, user_id: user.id},
        [%MovieDeleted{movie_id: movie.id, list_id: list.id, user_id: user.id}]
      )
    end
  end

  describe "UpdateMovie" do
    test "should emit MovieTagsChanged" do
      %{record: user = %{lists: [list]}} = aggregate = aggregate_with_a_list_and_a_movie()
      %{items: [movie]} = list
      params = build_movie_params(user_id: user.id, list_id: list.id, id: movie.id)

      assert_events(
        aggregate,
        struct(UpdateMovie, Factory.change_id_key(params, :movie_id)),
        [
          %MovieTagsChanged{
            movie_id: movie.id,
            tags: params.tags,
            user_id: user.id,
            list_id: list.id
          }
        ]
      )
    end
  end

  describe "CreateBook" do
    test "should emit BookCreated" do
      %{record: user = %{lists: [list]}} = aggregate = aggregate_with_a_list_and_a_book()
      command = build(:create_book_command, user_id: user.id, list_id: list.id)

      assert_events(
        aggregate,
        command,
        [struct(BookCreated, Utils.to_map(command))]
      )
    end
  end

  describe "DeleteBook" do
    test "should emit BookDeleted" do
      %{record: user = %{lists: [list]}} = aggregate = aggregate_with_a_list_and_a_book()
      %{items: [book]} = list

      assert_events(
        aggregate,
        %DeleteBook{book_id: book.id, list_id: list.id, user_id: user.id},
        [%BookDeleted{book_id: book.id, list_id: list.id, user_id: user.id}]
      )
    end
  end

  describe "UpdateBook" do
    test "should emit BookNotesChanged and BookTagsChanged" do
      %{record: user = %{lists: [list]}} = aggregate = aggregate_with_a_list_and_a_book()
      %{items: [%{id: id}]} = list
      params = build_book_params(user_id: user.id, list_id: list.id, id: id)

      assert_events(
        aggregate,
        struct(UpdateBook, Factory.change_id_key(params, :book_id)),
        [
          %BookTagsChanged{book_id: id, tags: params.tags, user_id: user.id, list_id: list.id},
          %BookNotesChanged{book_id: id, notes: params.notes, user_id: user.id, list_id: list.id}
        ]
      )
    end
  end

  defp aggregate_with_a_list_and_a_movie do
    %{id: id, record: user} = aggregate = build(:user_aggregate)
    command = build(:create_movie_command, user_id: id)
    movie = Movie.new(command.imdb_id, command.title, id: command.movie_id)

    list =
      command.title
      |> List.new("movie", id: command.list_id)
      |> List.add_item(movie)

    %{aggregate | record: User.add_list(user, list)}
  end

  defp aggregate_with_a_list_and_a_book do
    %{id: id, record: user} = aggregate = build(:user_aggregate)
    command = build(:create_book_command, user_id: id)
    book = Book.new(command.isbn, command.title, id: command.book_id)

    list =
      command.title
      |> List.new("book", id: command.list_id)
      |> List.add_item(book)

    %{aggregate | record: User.add_list(user, list)}
  end
end
