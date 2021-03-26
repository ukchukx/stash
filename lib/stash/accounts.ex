defmodule Stash.Accounts do
  alias Stash.Commands.{
    CreateList,
    CreateUser,
    DeleteList,
    DisableUser,
    EnableUser,
    UpdateList,
    UpdateUser
  }

  alias Stash.Queries.{ById, Users}
  alias Stash.{Commands, Queries}
  alias Stash.Projections.User
  alias Stash.Core.Utils

  def build_create_user_command(%{} = attrs) do
    attrs =
      attrs
      |> Map.delete(:active)
      |> Map.put(:user_id, Utils.new_id())

    CreateUser
    |> struct(attrs)
    |> CreateUser.downcase_email()
    |> CreateUser.hash_password()
  end

  def build_update_user_command(%{} = user, %{} = attrs) do
    UpdateUser
    |> struct(Map.delete(attrs, :active))
    |> UpdateUser.assign_user(user)
    |> UpdateUser.downcase_email()
    |> UpdateUser.hash_password()
  end

  def build_create_list_command(%{} = user, %{} = attrs) do
    attrs =
      attrs
      |> Map.put(:user_id, user.id)
      |> Map.put(:list_id, Utils.new_id())

    struct(CreateList, attrs)
  end

  def build_update_list_command(%{} = list, %{} = attrs) do
    attrs =
      %{}
      |> Map.put(:user_id, Utils.field_from_map(attrs, :user_id))
      |> Map.put(:list_id, Utils.field_from_map(list, :id))
      |> Map.put(:name, Utils.field_from_map(attrs, :name))

    struct(UpdateList, attrs)
  end

  def create_user(%{} = attrs) do
    attrs
    |> build_create_user_command
    |> Commands.dispatch()
    |> case do
      {:ok, %{id: id}} -> user_by_id(id)
      response -> response
    end
  end

  def update_user(%{id: id} = user, attrs = %{}) do
    with {:ok, %{}} <- user |> build_update_user_command(attrs) |> Commands.dispatch() do
      user_by_id(id)
    else
      reply -> reply
    end
  end

  def enable_user(%{id: id} = user) do
    with {:ok, %{active: false}} <- user_by_id(id),
         {:ok, _state} <- EnableUser |> struct(%{user_id: id}) |> Commands.dispatch() do
      {:ok, %{user | active: true}}
    else
      {:ok, _} -> {:error, :already_enabled}
      res -> res
    end
  end

  def disable_user(%{id: id} = user) do
    with {:ok, %{active: true}} <- user_by_id(id),
         {:ok, _state} <- DisableUser |> struct(%{user_id: id}) |> Commands.dispatch() do
      {:ok, %{user | active: false}}
    else
      {:ok, _} -> {:error, :already_disabled}
      res -> res
    end
  end

  def create_list(attrs = %{}, %{user: user = %{id: user_id}} = _context) do
    with {:ok, _state} <- user |> build_create_list_command(attrs) |> Commands.dispatch() do
      user_by_id(user_id)
    else
      reply -> reply
    end
  end

  def update_list(%{id: id} = _user, list_id, attrs = %{}) do
    with {:ok, %{lists: lists}} <- user_by_id(id),
         list = Enum.find(lists, &(&1["id"] == list_id)),
         true <- not is_nil(list),
         attrs = Map.put(attrs, :user_id, id),
         {:ok, %{id: id}} <- list |> build_update_list_command(attrs) |> Commands.dispatch() do
      user_by_id(id)
    else
      false -> {:error, :not_found}
      reply -> reply
    end
  end

  def delete_list(%{id: id} = _user, list_id) do
    with {:ok, %{lists: lists}} <- user_by_id(id),
         true <- Enum.any?(lists, &(&1["id"] == list_id)),
         attrs = %{list_id: list_id, user_id: id},
         {:ok, _state} <- DeleteList |> struct(attrs) |> Commands.dispatch() do
      :ok
    else
      res -> res
    end
  end

  def user_by_id(id), do: User |> ById.one(id) |> Queries.fetch_one()

  def user_by_email(email) do
    email
    |> String.downcase()
    |> Users.by_email()
    |> Queries.fetch_one()
  end
end
