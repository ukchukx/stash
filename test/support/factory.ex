defmodule Stash.Factory do
  alias Stash.Commands.{CreateUser, CreateBook, CreateList, CreateMovie}
  alias Stash.Aggregates.User, as: UserAggregate
  alias Stash.Support.Utils
  alias Stash.Core.User
  alias Stash.Core.Utils, as: CoreUtils

  use ExMachina

  def user_factory do
    %{
      id: CoreUtils.new_id(),
      password: Faker.Lorem.sentence(2..4),
      email: Faker.Internet.email(),
      active: true
    }
  end

  def list_factory do
    %{
      id: CoreUtils.new_id(),
      user_id: CoreUtils.new_id(),
      name: Faker.Commerce.product_name(),
      type: Faker.Util.pick(["book", "movie"])
    }
  end

  def book_factory do
    %{
      id: CoreUtils.new_id(),
      user_id: CoreUtils.new_id(),
      list_id: CoreUtils.new_id(),
      tags: [Faker.Lorem.word(), Faker.Lorem.word()],
      title: Faker.Commerce.product_name(),
      isbn: 13 |> Faker.Lorem.characters() |> to_string(),
      notes: Faker.Lorem.sentence(2..4),
      thumbnail: Faker.Internet.image_url()
    }
  end

  def movie_factory do
    %{
      id: CoreUtils.new_id(),
      user_id: CoreUtils.new_id(),
      list_id: CoreUtils.new_id(),
      tags: [Faker.Lorem.word(), Faker.Lorem.word()],
      title: Faker.Commerce.product_name(),
      imdb_id: 6 |> Faker.Lorem.characters() |> to_string(),
      thumbnail: Faker.Internet.image_url()
    }
  end

  def create_user_command_factory(attrs \\ []), do: struct(CreateUser, build_user_params(attrs))

  def user_aggregate_factory(attrs \\ []) do
    params = build(:user, attrs)
    user = User.new(params.email, Keyword.new(params))
    struct(UserAggregate, %{id: user.id, record: user})
  end

  def build_user_params(attrs \\ []), do: build(:user, attrs)

  def build_list_params(attrs \\ []), do: build(:list, attrs)

  def create_list_command_factory(attrs \\ []),
    do: struct(CreateList, attrs |> build_list_params |> change_id_key(:list_id))

  def create_book_command_factory(attrs \\ []),
    do: struct(CreateBook, attrs |> build_book_params |> change_id_key(:book_id))

  def build_book_params(attrs \\ []), do: build(:book, attrs)

  def create_movie_command_factory(attrs \\ []),
    do: struct(CreateMovie, attrs |> build_movie_params |> change_id_key(:movie_id))

  def build_movie_params(attrs \\ []), do: build(:movie, attrs)

  def change_id_key(map, key), do: map |> Map.put(key, map.id) |> Map.delete(:id)
end
