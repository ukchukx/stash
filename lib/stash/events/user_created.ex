defmodule Stash.Events.UserCreated do
  @derive Jason.Encoder
  defstruct [:user_id, :email, :active, :password]
end
