defmodule Covid19.Fetcher do
  use GenServer

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_updates()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Task.Supervisor.async(Task.UpdateSupervisor, &Covid19.Fetcher.State.update_states/0)
    Task.Supervisor.async(Task.UpdateSupervisor, &Covid19.Fetcher.County.update_counties/0)

    # schedule_updates()

    {:noreply, state}
  end

  def handle_info({_task, {:ok, result}}, state) do
    Logger.debug("#{inspect(result)} complete")
    {:noreply, state}
  end

  def handle_info({_task, {:error, reason}}, state) do
    Logger.error("#{inspect(reason)} failed")
    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  defp schedule_updates do
    Process.send_after(self(), :work, 600_000)
  end
end
