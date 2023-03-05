defmodule Letterboxd.Movies.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies" do
    field :title, :string
    field :overview, :string
    field :release_date, :date
    field :poster_url, :string
    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title, :overview, :release_date,  :poster_url])
    |> validate_required([:title, :overview, :release_date,  :poster_url])
  end
end
