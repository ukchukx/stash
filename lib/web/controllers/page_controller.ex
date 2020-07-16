defmodule Stash.Web.PageController do
  use Stash.Web, :controller

  alias Stash.{Books, Movies}

  def index(%{assigns: %{current_user: %{"id" => user_id} = user}} = conn, _) do
    books = Books.books_for_user(user_id)
    movies = Movies.movies_for_user(user_id)

    render conn, "index.html", user: user, books: books, movies: movies, page_title: "Home"
  end

  def index(conn, _), do: redirect(conn, to: Routes.session_path(conn, :signin))

  def catch_all(conn, _), do: redirect(conn, to: Routes.page_path(conn, :index))
end
