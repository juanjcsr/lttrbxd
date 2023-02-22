defmodule LetterboxdWeb.PageController do
  use LetterboxdWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
