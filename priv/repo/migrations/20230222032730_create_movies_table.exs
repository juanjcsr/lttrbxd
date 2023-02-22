defmodule Letterboxd.Repo.Migrations.CreateMoviesTable do
  use Ecto.Migration

  def up do
    create table(:movies) do
      add :title, :string
      add :overview, :string
      add :release_date, :date
      add :poster_url, :string

      timestamps()
    end

    create unique_index(:movies, [:title, :release_date])
  end

  def down do
    drop table(:movies)
  end
end
