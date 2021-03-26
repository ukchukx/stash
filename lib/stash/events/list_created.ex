defmodule Stash.Events.ListCreated do
  @derive Jason.Encoder
  defstruct [:user_id, :list_id, :name, :type]
end
