defmodule Covid19.Update.EtagAgent do
  use Agent

  require Logger

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def update_etag(etag, url) do
    Logger.info("updated etag: #{url} -> #{etag}")
    Agent.update(__MODULE__, &Map.put(&1, url, etag))
  end

  def get_etag(url) do
    Agent.get(__MODULE__, &Map.get(&1, url))
  end
end
