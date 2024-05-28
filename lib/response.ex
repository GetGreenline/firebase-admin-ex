defmodule FirebaseAdminEx.Response do
  def parse(%HTTPoison.Response{} = response) do
    case response do
      %HTTPoison.Response{status_code: 200, body: body} ->
        {:ok, body}

      %HTTPoison.Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  def parse(_response) do
    {:error, "Invalid response"}
  end
end
