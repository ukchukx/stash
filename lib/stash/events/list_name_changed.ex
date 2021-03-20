defmodule Stash.Events.ListNameChanged do
  @derive Jason.Encoder
  defstruct [:list_id, :user_id, :name]
end
