defmodule Stash.Fixture do
  alias Stash.{Accounts, Books, Movies}

  def fixture(resource, attrs \\ [])

  def fixture(:user, attrs), do: create_user(attrs)

  def fixture(:book, attrs), do: create_book(nil, attrs)

  def fixture(:movie, attrs), do: create_movie(nil, attrs)

  def create_user_having_a_list(list_type) do
    user =
      :user
      |> fixture()
      |> elem(1)

    list =
      user
      |> create_list(type: list_type)
      |> elem(1)

    %{user | lists: [list]}
  end

  def create_user(attrs \\ []),
    do: attrs |> Stash.Factory.build_user_params() |> Accounts.create_user()

  def create_list(user, attrs \\ []),
    do: attrs |> Stash.Factory.build_list_params() |> Accounts.create_list(user_context(user))

  def create_book(user, attrs \\ []),
    do: attrs |> Stash.Factory.build_book_params() |> Books.create_book(user_context(user))

  def create_movie(user, attrs \\ []),
    do: attrs |> Stash.Factory.build_movie_params() |> Movies.create_movie(user_context(user))

  def user_context(nil) do
    {:ok, user} = create_user()
    user_context(user)
  end

  def user_context(%{} = user), do: %{user: user}
end
