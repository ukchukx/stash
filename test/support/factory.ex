defmodule Stash.Factory do
  alias Stash.Commands.{CreateUser, CreateBook}
  alias Stash.Aggregates.{User, Book}
  alias Stash.Support.Utils

  use ExMachina

  def user_factory do
    %{
      id: Ecto.UUID.generate(),
      password: Faker.Lorem.sentence(2..4),
      email: Faker.Internet.email(),
      active: true
    }
  end

  def book_factory do
    %{
      id: Ecto.UUID.generate(),
      user_id: Ecto.UUID.generate(),
      tags: [Faker.Lorem.word(), Faker.Lorem.word()],
      title: Faker.Commerce.product_name(),
      isbn: 13 |> Faker.Lorem.characters |> to_string(),
      notes: "",
      thumbnail: Faker.Internet.image_url()
    }
  end

  def create_user_command_factory(attrs \\ []), do: struct(CreateUser, build_user_params(attrs))

  def user_aggregate_factory(attrs \\ []) do
    params =
      :create_user_command
      |> build(attrs)
      |> Utils.to_map
      |> Map.drop([:user_id])
      |> Map.put(:id, Ecto.UUID.generate())

    struct(User, params)
  end

  def build_user_params(attrs \\ []), do: build(:user, attrs)


  def create_book_command_factory(attrs \\ []), do: struct(CreateBook, build_book_params(attrs))

  def book_aggregate_factory(attrs \\ []) do
    params =
      :create_book_command
      |> build(attrs)
      |> Utils.to_map
      |> Map.drop([:book_id])
      |> Map.put(:id, Ecto.UUID.generate())

    struct(Book, params)
  end

  def build_book_params(attrs \\ []), do: build(:book, attrs)

end
