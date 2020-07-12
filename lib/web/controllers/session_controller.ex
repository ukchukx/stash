defmodule Stash.Web.SessionController do
  use Stash.Web, :controller

  def signin(%{assigns: %{current_user: %{}}} = conn, _) do
    redirect(conn, to: Routes.page_path(conn, :index))
  end

  def signin(conn, _) do
    render conn, "new.html", path: Routes.session_path(conn, :create_session), page_title: "Sign in"
  end

  def create_session(conn, %{"email" => email, "password" => pass}) do
    case Stash.Web.Support.Auth.auth_with_email_and_password(conn, email, pass) do
      {:ok, conn} -> redirect(conn, to: Routes.page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password")
        |> redirect(to: Routes.session_path(conn, :signin))
    end
  end

  def delete_session(conn, _) do
    conn
    |> clear_session
    |> redirect(to: Routes.session_path(conn, :signin))
  end
end
