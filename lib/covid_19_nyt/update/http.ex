defmodule Covid19.Update.HTTP do
  @moduledoc """
  HTTP functions for pulling down the CSV files. HTTP calls respect the ETag header to avoid fetching
  files that haven't changed.
  Based heavily on https://github.com/poeticoding/httpstream_articles
  """

  alias Covid19.Update.EtagAgent

  def get(url) do
    Stream.resource(
      fn -> start_fun(url) end,
      fn
        %HTTPoison.AsyncResponse{} = resp ->
          handle_async_resp(resp, url)

        {:end, resp} ->
          {:halt, resp}
      end,
      fn %HTTPoison.AsyncResponse{id: id} ->
        :hackney.stop_async(id)
      end
    )
  end

  defp start_fun(url) do
    etag = EtagAgent.get_etag(url)
    headers = if etag != nil, do: [{"If-None-Match", etag}], else: []
    HTTPoison.get!(url, headers, stream_to: self(), async: :once)
  end

  defp handle_async_resp(%HTTPoison.AsyncResponse{id: id} = resp, url) do
    receive do
      %HTTPoison.AsyncStatus{id: ^id, code: code} ->
        HTTPoison.stream_next(resp)
        {[], resp}

      %HTTPoison.AsyncHeaders{id: ^id, headers: headers} ->
        update_etag(headers, url)
        HTTPoison.stream_next(resp)
        {[], resp}

      %HTTPoison.AsyncChunk{id: ^id, chunk: chunk} ->
        HTTPoison.stream_next(resp)
        {[chunk], resp}

      %HTTPoison.AsyncEnd{id: ^id} ->
        {:halt, resp}
    after
      5_000 -> raise "receive timeout"
    end
  end

  defp update_etag(headers, url) do
    headers
    |> Enum.filter(fn {k, _} -> k == "ETag" end)
    |> hd
    |> elem(1)
    |> EtagAgent.update_etag(url)
  end

  def lines(enum), do: lines(enum, :string_split)

  def lines(enum, :next_lines) do
    enum
    |> Stream.transform("", &next_lines/2)
  end

  def lines(enum, :string_split) do
    enum
    |> Stream.transform("", fn
      :end, acc ->
        {[acc], ""}

      chunk, acc ->
        [last_line | lines] =
          String.split(acc <> chunk, "\n")
          |> Enum.reverse()

        {Enum.reverse(lines), last_line}
    end)
  end

  defp next_lines(:end, prev), do: {[prev], ""}

  defp next_lines(chunk, current_line) do
    next_lines(chunk, current_line, [])
  end

  defp next_lines(<<"\n"::utf8, rest::binary>>, current_line, lines) do
    next_lines(rest, "", [<<current_line::binary, "\n"::utf8>> | lines])
  end

  defp next_lines(<<c::utf8, rest::binary>>, current_line, lines) do
    next_lines(rest, <<current_line::binary, c::utf8>>, lines)
  end

  defp next_lines(<<>>, current_line, lines) do
    {Enum.reverse(lines), current_line}
  end
end
