defmodule Stash.Projectors.User do
  use Commanded.Projections.Ecto,
    name: "Projector.User",
    application: Stash.CommandedApp,
    consistency: :strong

  alias Stash.Events.{
    ListCreated,
    ListDeleted,
    ListNameChanged,
    UserEmailChanged,
    UserDisabled,
    UserEnabled,
    UserPasswordChanged,
    UserCreated
  }

  alias Stash.Projections.User
  alias Stash.Queries.{ById, Books, Movies}
  alias Stash.Support.Utils
  alias Stash.Accounts

  project(%UserCreated{user_id: id} = event, fn multi ->
    changes =
      event
      |> Utils.to_map()
      |> Map.drop([:user_id])
      |> Map.put(:id, id)
      |> Map.put(:lists, [])

    Ecto.Multi.insert(multi, :user, struct(User, changes))
  end)

  project(%UserDisabled{user_id: id}, fn multi ->
    update_user(multi, id, active: false)
  end)

  project(%UserEnabled{user_id: id}, fn multi ->
    update_user(multi, id, active: true)
  end)

  project(%UserEmailChanged{user_id: id, email: email}, fn multi ->
    update_user(multi, id, email: email)
  end)

  project(%UserPasswordChanged{user_id: id, password: hashed_password}, fn multi ->
    update_user(multi, id, password: hashed_password)
  end)

  project(%ListCreated{list_id: id, user_id: user_id} = event, fn multi ->
    {:ok, %{lists: lists}} = Accounts.user_by_id(user_id)

    changes =
      event
      |> Utils.to_map()
      |> Map.drop([:user_id, :list_id])
      |> Map.put(:id, id)

    update_user(multi, user_id, lists: [changes | lists])
  end)

  project(%ListDeleted{list_id: id, user_id: user_id}, fn multi ->
    {:ok, %{lists: lists}} = Accounts.user_by_id(user_id)

    lists =
      lists
      |> Enum.filter(fn
        %{"id" => ^id} -> false
        _ -> true
      end)

    multi
    |> update_user(user_id, lists: lists)
    |> Ecto.Multi.delete_all(:user_books, Books.by_user_and_list(user_id, id))
    |> Ecto.Multi.delete_all(:user_movies, Movies.by_user_and_list(user_id, id))
  end)

  project(%ListNameChanged{list_id: id, user_id: user_id, name: name}, fn multi ->
    {:ok, %{lists: lists}} = Accounts.user_by_id(user_id)

    lists =
      lists
      |> Enum.map(fn
        %{"id" => ^id} = list -> %{list | "name" => name}
        list -> list
      end)

    update_user(multi, user_id, lists: lists)
  end)

  defp update_user(multi, id, changes) do
    Ecto.Multi.update_all(multi, :user, ById.one(User, id), set: changes)
  end
end
