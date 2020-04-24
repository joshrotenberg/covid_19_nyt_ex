defmodule Covid19.Data do
  @moduledoc """
  The Data context.
  """
  alias Covid19.Data.{County, State, US}
  alias Covid19.Repo

  import Ecto.Query, warn: false

  @bay_area_counties [
    "Alameda",
    "Contra Costa",
    "Marin",
    "Napa",
    "San Francisco",
    "San Mateo",
    "Santa Clara",
    "Solano",
    "Sonoma"
  ]

  def list_states do
    Repo.all(from s in State, order_by: s.date)
  end

  def list_counties do
    Repo.all(from c in County, order_by: c.date)
  end

  def list_us do
    Repo.all(from u in US, order_by: u.date)
  end

  def get_state!(name) do
    Repo.all(
      from s in State,
        where: ilike(s.state, ^name),
        order_by: s.date
    )
  end

  def get_state_by_fips!(fips) do
    Repo.all(
      from s in State,
        where: s.fips == ^fips,
        order_by: s.date
    )
  end

  def upsert_state(attrs) do
    changeset = State.changeset(%State{}, attrs)

    Repo.insert(changeset,
      on_conflict: [
        set: [cases: changeset.changes.cases, deaths: changeset.changes.deaths]
      ],
      conflict_target: [:date, :state]
    )
  end

  def get_county!(state, county) do
    Repo.all(
      from c in County,
        where: ilike(c.state, ^state) and ilike(c.county, ^county),
        order_by: c.date
    )
  end

  def get_county_by_fips!(fips) do
    Repo.all(
      from c in County,
        where: c.fips == ^fips,
        order_by: c.date
    )
  end

  def upsert_county(attrs) do
    changeset = County.changeset(%County{}, attrs)

    Repo.insert(changeset,
      on_conflict: [
        set: [cases: changeset.changes.cases, deaths: changeset.changes.deaths]
      ],
      conflict_target: [:date, :county, :state]
    )
  end

  def upsert_us(attrs) do
    changeset = US.changeset(%US{}, attrs)

    Repo.insert(changeset,
      on_conflict: [
        set: [cases: changeset.changes.cases, deaths: changeset.changes.deaths]
      ],
      conflict_target: [:date]
    )
  end

  def missing_fips do
    Repo.all(from c in County, where: is_nil(c.fips))
  end

  def bay_area do
    Repo.all(
      from c in County,
        where: c.county in @bay_area_counties,
        order_by: c.date
    )
  end

  def create_state(attrs \\ %{}) do
    %State{}
    |> State.changeset(attrs)
    |> Repo.insert()
  end

  def create_county(attrs \\ %{}) do
    %County{}
    |> County.changeset(attrs)
    |> Repo.insert()
  end
end
