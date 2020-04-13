defmodule Covid19.Update.CSV do
  require Logger

  def decode(stream) do
    CSV.decode(stream, headers: true)
    |> Stream.reject(fn record ->
      case record do
        {:ok, _r} ->
          false

        _ ->
          Logger.warn(inspect(record))
          true
      end
    end)
  end

  def p(path) do
    File.stream!(path)
    |> CSV.decode(headers: true)
    # |> Stream.map(&IO.inspect(&1))
    # |> Stream.map(&extract_fips/1)
    |> Stream.reject(&rej/1)
    |> Enum.to_list()
  end

  def rej({:ok, r}) do
    case r["fips"] do
      "" -> false
      _ -> true
    end
  end

  def extract_fips({:ok, r}) do
    Map.get(r, "fips")
  end
end
