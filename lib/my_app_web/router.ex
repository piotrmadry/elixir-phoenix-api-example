defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api/v1", MyAppWeb do
    pipe_through(:api)
    get("/users", UserController, :index)
    get("/users/:id", UserController, :show)
    post("/users/create", UserController, :create)
    delete("/users", UserController, :delete)
  end
end
