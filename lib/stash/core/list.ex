defmodule Stash.Core.List do
  @moduledoc false

  alias Stash.Core.Utils

  defstruct [:id, :name, :type, items: []]

  def new(name, type, opts \\ []) when type in ~w(book movie) do
    attrs = %{
      name: name,
      id: Keyword.get(opts, :id, Utils.new_id()),
      type: type,
      items: Keyword.get(opts, :items, [])
    }

    struct!(__MODULE__, attrs)
  end

  def retrieve_item(%__MODULE__{items: items}, id), do: Enum.find(items, &(&1.id == id))

  def replace_item(list = %__MODULE__{items: items}, item = %{id: id}) do
    items =
      Enum.map(items, fn
        %{id: ^id} -> item
        x -> x
      end)

    %{list | items: items}
  end

  def add_item(list = %__MODULE__{items: items}, item = %{}),
    do: %{list | items: [item | items]}

  def remove_item(list = %__MODULE__{items: items}, id) do
    %{list | items: Enum.filter(items, &(&1.id != id))}
  end
end
