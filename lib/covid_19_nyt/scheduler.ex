defmodule Covid19.Scheduler do
  @moduledoc """
  CSV file update pipeline scheduler.
  """
  use Quantum,
    otp_app: :covid_19_nyt
end
