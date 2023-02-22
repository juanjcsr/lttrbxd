defmodule MovieFetcher do
  require HTTPoison

  @base_url "https://api.themoviedb.org/3"
  @api_key "15797043e4f38ebb7d5470888f4af6e0"

  def fetch_movie(title) do
    query_params = %{api_key: @api_key, query: title}

    fullurl = "#{@base_url}/search/movie"
      |> URI.parse()
      |>Map.put(:query, URI.encode_query(query_params))
      |>URI.to_string()
    response = HTTPoison.get(fullurl)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect(body["results"])
        movie = body["results"]
          #|> Jason.decode!()
          #|> Map.get("results")
          #|> IO.inspect()
          #|> List.first()
          |> Enum.at(0)
          |> Map.take(["title", "overview", "release_date", "poster_path"])
          |> Map.put("poster_path", get_poster_url(body["poster_path"]))
          #|> Map.get("id")
          #|> fetch_movie_details()
        {:ok, movie}
      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, status}
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
        {:error, reason}
    end

  end

  def fetch_movie_details(movie_id) do
    query_params = %{api_key: @api_key}

    fullurl = "#{@base_url}/movie/#{movie_id}"
      |> URI.parse()
      |>Map.put(:query, URI.encode_query(query_params))
      |>URI.to_string()

    response = HTTPoison.get(fullurl)
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        movie = body
          |> Jason.decode!()
          |> Map.get("overview")

        {:ok, movie}
      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, status}
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
        {:error, reason}
    end

  end


  defp get_poster_url(path) do
    "https://image.tmdb.org/t/p/w500#{path}"
  end
end
