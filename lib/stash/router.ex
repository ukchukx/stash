defmodule Stash.Router do
  alias Stash.Middleware.{Telemetry, Uniqueness, Validate}
  alias Stash.Aggregates.{User}
  alias Stash.Commands.{
    CreateUser,
    DisableUser,
    EnableUser,
    UpdateUser
  }

  use Commanded.Commands.Router

  middleware Telemetry
  middleware Validate
  middleware Uniqueness

  identify User, by: :user_id,   prefix: "user-"

  dispatch [
    CreateUser,
    DisableUser,
    EnableUser,
    UpdateUser
  ], to: User, lifespan: User, timeout: Application.get_env(:stash, :router)[:timeout]

end
