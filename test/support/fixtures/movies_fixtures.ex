defmodule Letterboxd.MoviesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Letterboxd.Movies` context.
  """

  @doc """
  Generate a movie.
  """
  def movie_fixture(attrs \\ %{}) do
    {:ok, movie} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Letterboxd.Movies.create_movie()

    movie
  end
end
