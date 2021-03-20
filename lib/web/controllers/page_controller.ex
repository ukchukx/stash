defmodule Stash.Web.PageController do
  use Stash.Web, :controller

  require Logger

  alias Stash.{Books, Movies}

  def index(%{assigns: %{current_user: %{"id" => user_id} = user}} = conn, _) do
    books = Books.books_for_user(user_id)
    movies = Movies.movies_for_user(user_id)
    tmdb_token = Application.get_env(:stash, :tmdb_token)

    render(conn, "index.html",
      user: user,
      books: books,
      movies: movies,
      page_title: "Home",
      tmdb_token: tmdb_token
    )
  end

  def index(conn, _), do: redirect(conn, to: Routes.session_path(conn, :signin))

  def create_movie(%{assigns: %{current_user: %{"id" => user_id}}} = conn, params) do
    context = %{user: %{id: user_id}}

    with {:ok, movie} <-
           params |> AtomizeKeys.atomize_string_keys() |> Stash.Movies.create_movie(context) do
      conn
      |> Plug.Conn.put_status(201)
      |> json(%{data: movie})
    else
      {:error, err} ->
        Logger.error("Error while creating movie #{inspect(err)}")

        conn
        |> Plug.Conn.put_status(400)
        |> json(%{error: "Could not create movie"})
    end
  end

  def create_book(%{assigns: %{current_user: %{"id" => user_id}}} = conn, params) do
    context = %{user: %{id: user_id}}

    with {:ok, book} <-
           params |> AtomizeKeys.atomize_string_keys() |> Stash.Books.create_book(context) do
      conn
      |> Plug.Conn.put_status(201)
      |> json(%{data: book})
    else
      {:error, err} ->
        Logger.error("Error while creating book #{inspect(err)}")

        conn
        |> Plug.Conn.put_status(400)
        |> json(%{error: "Could not create book"})
    end
  end

  def delete_movie(%{assigns: %{current_user: %{"id" => _user_id}}} = conn, %{"id" => id}) do
    with :ok <- Stash.Movies.delete_movie(%{id: id}) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(204, "")
    else
      {:error, err} ->
        Logger.error("Error while deleting movie #{inspect(err)}")

        conn
        |> Plug.Conn.put_status(400)
        |> json(%{error: "Could not delete movie"})
    end
  end

  def delete_book(%{assigns: %{current_user: %{"id" => _user_id}}} = conn, %{"id" => id}) do
    with :ok <- Stash.Books.delete_book(%{id: id}) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(204, "")
    else
      {:error, err} ->
        Logger.error("Error while deleting book #{inspect(err)}")

        conn
        |> Plug.Conn.put_status(400)
        |> json(%{error: "Could not delete book"})
    end
  end

  def catch_all(conn, _), do: redirect(conn, to: Routes.page_path(conn, :index))
end
