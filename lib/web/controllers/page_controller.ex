defmodule Stash.Web.PageController do
  use Stash.Web, :controller

  require Logger

  alias Stash.{Accounts, Books, Movies}

  def index(%{assigns: %{current_user: %{"id" => user_id} = user}} = conn, _) do
    {:ok, user} = Accounts.user_by_id(user_id)
    tmdb_token = Application.get_env(:stash, :tmdb_token)

    render(conn, "index.html",
      user: user,
      page_title: "Home",
      tmdb_token: tmdb_token
    )
  end

  def index(conn, _), do: redirect(conn, to: Routes.session_path(conn, :signin))

  def lists(%{assigns: %{current_user: %{"id" => user_id}}} = conn, _) do
    {:ok, %{lists: lists}} = Accounts.user_by_id(user_id)
    json(conn, %{data: lists})
  end

  def movies_in_list(%{assigns: %{current_user: %{"id" => user_id}}} = conn, %{"id" => list_id}) do
    movies = Movies.movies_by_user_and_list(user_id, list_id)
    json(conn, %{data: movies})
  end

  def books_in_list(%{assigns: %{current_user: %{"id" => user_id}}} = conn, %{"id" => list_id}) do
    books = Movies.books_by_user_and_list(user_id, list_id)
    json(conn, %{data: books})
  end

  def create_list(%{assigns: %{current_user: %{"id" => user_id}}} = conn, %{} = params) do
    {:ok, %{lists: lists}} = Accounts.user_by_id(user_id)
    existing_list_ids = Enum.map(lists, & &1["id"])
    attrs =
      params
      |> AtomizeKeys.atomize_string_keys()
      |> Map.take([:name, :type])

    {:ok, %{lists: lists}} = Accounts.create_list(attrs, %{user: %{id: user_id}})
    new_list = Enum.find(lists, & &1["id"] not in existing_list_ids)

    conn
    |> put_status(201)
    |> json(%{data: new_list})
  end

  def delete_list(%{assigns: %{current_user: %{"id" => user_id}}} = conn, %{"id" => list_id}) do
    :ok = Accounts.delete_list(%{id: user_id}, list_id)
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(204, "")
  end

  def create_movie(%{assigns: %{current_user: %{"id" => user_id}}} = conn, params) do
    attrs =
      params
      |> AtomizeKeys.atomize_string_keys()
      |> Map.take([:title, :imdb_id, :list_id, :thumbnail])
      |> Map.put(:user_id, user_id)

    with {:ok, movie} <- Movies.create_movie(attrs, %{user: %{id: user_id}}) do
      conn
      |> put_status(201)
      |> json(%{data: movie})
    else
      {:error, err} ->
        Logger.error("Error while creating movie #{inspect(err)}")

        conn
        |> put_status(400)
        |> json(%{error: "Could not create movie"})
    end
  end

  def delete_movie(%{assigns: %{current_user: %{"id" => user_id}}} = conn, %{"id" => id}) do
    with :ok <- Movies.delete_movie(%{user_id: user_id, id: id}) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(204, "")
    else
      {:error, err} ->
        Logger.error("Error while deleting movie #{inspect(err)}")

        conn
        |> put_status(400)
        |> json(%{error: "Could not delete movie"})
    end
  end

  def create_book(%{assigns: %{current_user: %{"id" => user_id}}} = conn, params) do
    attrs =
      params
      |> AtomizeKeys.atomize_string_keys()
      |> Map.take([:title, :imdb_id, :list_id, :isbn, :thumbnail])
      |> Map.put(:user_id, user_id)

    with {:ok, book} <- Books.create_book(attrs, %{user: %{id: user_id}}) do
      conn
      |> put_status(201)
      |> json(%{data: book})
    else
      {:error, err} ->
        Logger.error("Error while creating book #{inspect(err)}")

        conn
        |> put_status(400)
        |> json(%{error: "Could not create book"})
    end
  end

  def delete_book(%{assigns: %{current_user: %{"id" => user_id}}} = conn, %{"id" => id}) do
    with :ok <- Books.delete_book(%{user_id: user_id, id: id}) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(204, "")
    else
      {:error, err} ->
        Logger.error("Error while deleting book #{inspect(err)}")

        conn
        |> put_status(400)
        |> json(%{error: "Could not delete book"})
    end
  end

  def catch_all(conn, params), do: index(conn, params)
end
