defmodule Covid19.Fetcher.CSV do
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
end
