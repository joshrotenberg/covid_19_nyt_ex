defmodule Covid19.Update.CSV do
  @moduledoc """
  CSV decode wrapper.
  """
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
