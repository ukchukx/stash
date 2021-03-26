defmodule Stash.Core.User do
  @moduledoc false

  alias Stash.Core.{List, Utils}

  defstruct [:id, :email, :password, lists: [], active: true]

  def new(email, opts \\ []) do
    attrs = %{
      email: email,
      id: Keyword.get(opts, :id, Utils.new_id()),
      password: Keyword.get(opts, :password),
      active: Keyword.get(opts, :active, true),
      lists: Keyword.get(opts, :lists, [])
    }

    struct!(__MODULE__, attrs)
  end

  def change_password(user = %__MODULE__{}, password), do: %{user | password: password}

  def change_email(user = %__MODULE__{}, email), do: %{user | email: email}

  def enable(user = %__MODULE__{}), do: %{user | active: true}

  def disable(user = %__MODULE__{}), do: %{user | active: false}

  def retrieve_list(%__MODULE__{lists: lists}, id), do: Enum.find(lists, &(&1.id == id))

  def add_list(user = %__MODULE__{lists: lists}, list = %List{}),
    do: %{user | lists: [list | lists]}

  def retrieve_item_in_list(user = %__MODULE__{}, list_id, item_id) do
    with list = %List{} <- retrieve_list(user, list_id),
         item <- List.retrieve_item(list, item_id) do
      item
    else
      _ -> nil
    end
  end

  def retrieve_item_by_function(_user = %__MODULE__{lists: lists}, item_id, func \\ nil) do
    func =
      case func do
        nil -> fn x -> x.id == item_id end
        func -> func
      end

    lists
    |> Enum.flat_map(& &1.items)
    |> Enum.find(&func.(&1))
  end

  def replace_list(user = %__MODULE__{lists: lists}, list = %List{id: id}) do
    lists =
      Enum.map(lists, fn
        %List{id: ^id} -> list
        x -> x
      end)

    %{user | lists: lists}
  end

  def remove_list(user = %__MODULE__{lists: lists}, list_id) do
    lists =
      Enum.filter(lists, fn
        %List{id: ^list_id} -> false
        _ -> true
      end)

    %{user | lists: lists}
  end
end
