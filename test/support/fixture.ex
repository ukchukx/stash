defmodule Stash.Fixture do
  alias Stash.{Accounts, Books, Movies}

  def fixture(resource, attrs \\ [])

  def fixture(:user, attrs), do: create_user(attrs)

  def fixture(:book, attrs), do: create_book(attrs)

  def fixture(:movie, attrs), do: create_movie(attrs)

  defp create_user(attrs \\ []), do: attrs |> Stash.Factory.build_user_params |> Accounts.create_user

  defp create_book(attrs \\ []), do: attrs |> Stash.Factory.build_book_params |> Books.create_book(user_context())

  defp create_movie(attrs \\ []), do: attrs |> Stash.Factory.build_movie_params |> Movies.create_movie(user_context())


  def user_context do
    {:ok, user}  = create_user()

    user_context(user)
  end

  def user_context(%{} = user), do: %{user: user}

end
