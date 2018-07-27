defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller

  def index(conn, _params) do
    users = MyApp.Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    with user = %MyApp.Auth.User{} <- MyApp.Auth.get_user(id) do
      render(conn, "show.json", user: user)
    else
      nil ->
        conn
        |> put_status(404)
        |> render(MyAppWeb.ErrorView, "404.json", error: "User not found")
    end
  end

  def create(conn, %{"name" => name, "email" => email, "password" => password}) do
    data = %{"name" => name, "email" => email, "password" => password}

    case MyApp.Auth.create_user(data) do
      {:ok, user} ->
        conn
        |> put_status(200)
        |> render(MyAppWeb.UserView, "show.json", user: user)

      {:error, message} ->
        conn
        |> put_status(404)
        |> render(MyAppWeb.ErrorView, "404.json", error: message)
    end
  end

  def delete(conn, %{"id" => id}) do
    case MyApp.Auth.delete_user(MyApp.Auth.get_user(id)) do
      {:ok, _user} ->
        conn
        |> put_status(200)
        |> json(%{data: "No i pięknie go wyjebało"})

      {:error, message} ->
        conn
        |> put_status(404)
        |> render(MyAppWeb.ErrorView, "404.json", error: message)
    end
  end
end
