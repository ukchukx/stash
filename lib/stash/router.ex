defmodule Stash.Router do
  alias Stash.Middleware.{Telemetry, Uniqueness, Validate}
  alias Stash.Aggregates.{User, Book}
  alias Stash.Commands.{
    CreateUser,
    DisableUser,
    EnableUser,
    UpdateUser,
    CreateBook,
    UpdateBook,
    DeleteBook
  }

  use Commanded.Commands.Router

  middleware Telemetry
  middleware Validate
  middleware Uniqueness

  identify User, by: :user_id,   prefix: "user-"
  identify Book, by: :book_id,   prefix: "book-"

  dispatch [
    CreateUser,
    DisableUser,
    EnableUser,
    UpdateUser
  ], to: User, lifespan: User, timeout: Application.get_env(:stash, :router)[:timeout]

  dispatch [
    CreateBook,
    UpdateBook,
    DeleteBook
  ], to: Book, lifespan: Book, timeout: Application.get_env(:stash, :router)[:timeout]
end
