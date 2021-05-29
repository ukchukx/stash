defmodule Stash.Web.SessionController do
  use Stash.Web, :controller
  require Logger

  def signin(%{assigns: %{current_user: %{}}} = conn, _) do
    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def signin(conn, _) do
    render(conn, "signin.html", page_title: "Sign in")
  end

  def signup(%{assigns: %{current_user: %{}}} = conn, _) do
    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def signup(conn, _) do
    render(conn, "signup.html", page_title: "Sign up")
  end

  def create_account(conn, %{"email" => email, "password" => pass}) do
    with {:ok, %{}} <- Stash.Accounts.create_user(%{email: email, password: pass}),
         {:ok, conn} <- Stash.Web.Support.Auth.auth_with_email_and_password(conn, email, pass) do
      conn
      |> put_status(201)
      |> json(%{created: true})
    else
      err ->
        Logger.error("Could not create account due to: #{inspect(err)}")
        conn
        |> put_status(400)
        |> json(%{created: false})
    end
  end

  def create_session(conn, %{"email" => email, "password" => pass}) do
    case Stash.Web.Support.Auth.auth_with_email_and_password(conn, email, pass) do
      {:ok, conn} -> json(conn, %{authenticated: true})
      {:error, _reason, conn} -> json(conn, %{authenticated: false})
    end
  end

  def delete_session(conn, _) do
    conn
    |> clear_session
    |> redirect(to: Routes.session_path(conn, :signin))
  end
end
