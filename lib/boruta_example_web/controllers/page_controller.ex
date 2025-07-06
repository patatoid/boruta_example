defmodule BorutaExampleWeb.PageController do
  use BorutaExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def wallet(conn, _params) do
    conn
    |> put_layout(false)
    |> render("wallet.html")
  end
end
