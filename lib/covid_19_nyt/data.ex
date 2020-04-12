defmodule Covid19.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias Covid19.Repo

  alias Covid19.Data.{State, County}

  def list_states do
    Repo.all(State)
  end

  def list_counties do
    Repo.all(County)
  end

  def get_state!(name) do
    Repo.all(from s in State, where: ilike(s.state, ^name))
  end

  def get_state_by_fips!(fips) do
    Repo.all(from s in State, where: s.fips == ^fips)
  end

  def get_county!(state, county) do
    Repo.all(
      from c in County,
        where: ilike(c.state, ^state) and ilike(c.county, ^county)
    )
  end

  def get_county_by_fips!(fips) do
    Repo.all(from c in County, where: c.fips == ^fips)
  end

  def missing_fips() do
    Repo.all(from c in County, where: is_nil(c.fips))
  end
end
