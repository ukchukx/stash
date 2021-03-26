defmodule Stash.Core.Utils do
  @moduledoc false

  def new_id, do: UUID.uuid4()

  def field_from_map(map, field) when is_binary(field), do: Map.get(map, field)

  def field_from_map(map, field) when is_atom(field) do
    case Map.get(map, field) do
      nil -> field_from_map(map, to_string(field))
      val -> val
    end
  end
end
