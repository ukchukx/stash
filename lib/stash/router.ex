defmodule Stash.Router do
  alias Stash.Aggregates.User

  alias Stash.Commands.{
    CreateBook,
    UpdateBook,
    DeleteBook,
    CreateList,
    DeleteList,
    UpdateList,
    CreateMovie,
    UpdateMovie,
    DeleteMovie,
    CreateUser,
    DisableUser,
    EnableUser,
    UpdateUser
  }

  alias Stash.Middleware.{Telemetry, Uniqueness, Validate}

  use Commanded.Commands.Router

  middleware(Telemetry)
  middleware(Validate)
  middleware(Uniqueness)

  identify(User, by: :user_id, prefix: "user-")

  dispatch(
    [
      CreateBook,
      DeleteBook,
      UpdateBook,
      CreateList,
      DeleteList,
      UpdateList,
      CreateMovie,
      UpdateMovie,
      DeleteMovie,
      CreateUser,
      DisableUser,
      EnableUser,
      UpdateUser
    ],
    to: User,
    lifespan: User,
    timeout: Application.get_env(:stash, :router)[:timeout]
  )
end
