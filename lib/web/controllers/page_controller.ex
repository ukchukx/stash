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

  def create_list(%{assigns: %{current_user: %{"id" => user_id}}} = conn, %{} = params) do
    {:ok, %{lists: lists}} = Accounts.user_by_id(user_id)
    existing_list_ids = Enum.map(lists, & &1["id"])
    attrs = %{name: params["name"], type: params["type"]}

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
    with :ok <- Movies.delete_movie(%{id: id}) do
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
    with :ok <- Books.delete_book(%{id: id}) do
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

  def catch_all(conn, params), do: index(conn, params)
end
