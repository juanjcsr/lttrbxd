defmodule LetterboxdWeb.MovieController do
  use LetterboxdWeb, :controller

  alias Letterboxd.Movies
  alias Letterboxd.Movies.Movie


  def index(conn, _params) do
    movies = Movies.list_movies()
    render(conn, "index.html", movies: movies)
  end

  def new(conn, _params) do
    changeset = Movies.change_movie(%Movie{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"movie" => %{"title" => title}}) do
    case MovieFetcher.fetch_movie(title) do
      {:ok, movie} ->
        changeset = Movies.change_movie(%Movie{}, movie)
        IO.inspect(changeset)
        #case Movies.create_movie(changeset) do
        case Movies.insert_movie(changeset) do
          {:ok, movie} ->
            conn
            |> put_flash(:info, "Movie created successfully.")
            |> redirect(to: Routes.movie_path(conn, :show, movie))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      {:error, reason} ->
        IO.inspect(reason)
        conn
        |> put_flash(:error, "Movie not found.")
        |> redirect(to: Routes.movie_path(conn, :index))
    end


    # case Movies.create_movie(movie_params) do
    #   {:ok, movie} ->
    #     conn
    #     |> put_flash(:info, "Movie created successfully.")
    #     |> redirect(to: Routes.movie_path(conn, :show, movie))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end

  def show(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    render(conn, "show.html", movie: movie)
  end

  def edit(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    changeset = Movies.change_movie(movie)
    render(conn, "edit.html", movie: movie, changeset: changeset)
  end

  def update(conn, %{"id" => id, "movie" => movie_params}) do
    movie = Movies.get_movie!(id)

    case Movies.update_movie(movie, movie_params) do
      {:ok, movie} ->
        conn
        |> put_flash(:info, "Movie updated successfully.")
        |> redirect(to: Routes.movie_path(conn, :show, movie))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", movie: movie, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    {:ok, _movie} = Movies.delete_movie(movie)

    conn
    |> put_flash(:info, "Movie deleted successfully.")
    |> redirect(to: Routes.movie_path(conn, :index))
  end
end
