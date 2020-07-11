defmodule Stash.Fixture do
  alias Stash.{Accounts, Books}

  def fixture(resource, attrs \\ [])

  def fixture(:user, attrs), do: create_user(attrs)

  def fixture(:book, attrs), do: create_book(attrs)

  defp create_user(attrs \\ []), do: attrs |> Stash.Factory.build_user_params |> Accounts.create_user

  defp create_book(attrs \\ []), do: attrs |> Stash.Factory.build_book_params |> Books.create_book(user_context())


  def user_context do
    {:ok, user}  = create_user()

    user_context(user)
  end

  def user_context(%{} = user), do: %{user: user}

end
