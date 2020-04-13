defmodule Covid19.Update.MetaData do
  use GenServer
  @ets_table :metadata

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    IO.puts("in init")
    metadata = :ets.new(@ets_table, [:set, :public, :named_table])
    {:ok, nil}
  end

  def etag(url) do
    :ets.lookup(@ets_table, url)
  end

  def etag(etag, url) do
    :ets.insert(@ets_table, {url, etag})
  end

  def last_county_update(datetime) do
    :ets.insert(@ets_table, {:last_county_update, datetime})
  end

  def last_county_update do
    :ets.lookup(@ets_table, :last_county_update)
  end

  def last_state_update(datetime) do
    :ets.insert(@ets_table, {:last_state_update, datetime})
  end

  def last_state_update do
    :ets.lookup(@ets_table, :last_state_update)
  end
end
