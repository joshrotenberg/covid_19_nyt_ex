defmodule Covid19.DataTest do
  use Covid19.DataCase

  alias Covid19.Data

  @tag :skip
  describe "states" do
    alias Covid19.Data.State

    @valid_attrs %{cases: 42, date: ~D[2010-04-17], deaths: 42, fips: 42, state: "some state"}
    @update_attrs %{
      cases: 43,
      date: ~D[2011-05-18],
      deaths: 43,
      fips: 43,
      state: "some updated state"
    }
    @invalid_attrs %{cases: nil, date: nil, deaths: nil, fips: nil, state: nil}

    def state_fixture(attrs \\ %{}) do
      {:ok, state} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_state()

      state
    end

    @tag :skip
    test "list_states/0 returns all states" do
      state = state_fixture()
      assert Data.list_states() == [state]
    end

    @tag :skip
    test "get_state!/1 returns the state with given id" do
      state = state_fixture()
      assert Data.get_state!(state.id) == state
    end

    @tag :skip
    test "create_state/1 with valid data creates a state" do
      assert {:ok, %State{} = state} = Data.create_state(@valid_attrs)
      assert state.cases == 42
      assert state.date == ~D[2010-04-17]
      assert state.deaths == 42
      assert state.fips == 42
      assert state.state == "some state"
    end

    @tag :skip
    test "create_state/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_state(@invalid_attrs)
    end

    @tag :skip
    test "update_state/2 with valid data updates the state" do
      state = state_fixture()
      assert {:ok, %State{} = state} = Data.update_state(state, @update_attrs)
      assert state.cases == 43
      assert state.date == ~D[2011-05-18]
      assert state.deaths == 43
      assert state.fips == 43
      assert state.state == "some updated state"
    end

    @tag :skip
    test "update_state/2 with invalid data returns error changeset" do
      state = state_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_state(state, @invalid_attrs)
      assert state == Data.get_state!(state.id)
    end

    @tag :skip
    test "delete_state/1 deletes the state" do
      state = state_fixture()
      assert {:ok, %State{}} = Data.delete_state(state)
      assert_raise Ecto.NoResultsError, fn -> Data.get_state!(state.id) end
    end

    @tag :skip
    test "change_state/1 returns a state changeset" do
      state = state_fixture()
      assert %Ecto.Changeset{} = Data.change_state(state)
    end
  end

  describe "counties" do
    alias Covid19.Data.County

    @valid_attrs %{
      cases: 42,
      county: "some county",
      date: ~D[2010-04-17],
      deaths: 42,
      fips: 42,
      state: "some state"
    }
    @update_attrs %{
      cases: 43,
      county: "some updated county",
      date: ~D[2011-05-18],
      deaths: 43,
      fips: 43,
      state: "some updated state"
    }
    @invalid_attrs %{cases: nil, county: nil, date: nil, deaths: nil, fips: nil, state: nil}

    def county_fixture(attrs \\ %{}) do
      {:ok, county} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_county()

      county
    end

    @tag :skip
    test "list_counties/0 returns all counties" do
      county = county_fixture()
      assert Data.list_counties() == [county]
    end

    @tag :skip
    test "get_county!/1 returns the county with given id" do
      county = county_fixture()
      assert Data.get_county!(county.id) == county
    end

    @tag :skip
    test "create_county/1 with valid data creates a county" do
      assert {:ok, %County{} = county} = Data.create_county(@valid_attrs)
      assert county.cases == 42
      assert county.county == "some county"
      assert county.date == ~D[2010-04-17]
      assert county.deaths == 42
      assert county.fips == 42
      assert county.state == "some state"
    end

    @tag :skip
    test "create_county/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_county(@invalid_attrs)
    end

    @tag :skip
    test "update_county/2 with valid data updates the county" do
      county = county_fixture()
      assert {:ok, %County{} = county} = Data.update_county(county, @update_attrs)
      assert county.cases == 43
      assert county.county == "some updated county"
      assert county.date == ~D[2011-05-18]
      assert county.deaths == 43
      assert county.fips == 43
      assert county.state == "some updated state"
    end

    @tag :skip
    test "update_county/2 with invalid data returns error changeset" do
      county = county_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_county(county, @invalid_attrs)
      assert county == Data.get_county!(county.id)
    end

    @tag :skip
    test "delete_county/1 deletes the county" do
      county = county_fixture()
      assert {:ok, %County{}} = Data.delete_county(county)
      assert_raise Ecto.NoResultsError, fn -> Data.get_county!(county.id) end
    end

    @tag :skip
    test "change_county/1 returns a county changeset" do
      county = county_fixture()
      assert %Ecto.Changeset{} = Data.change_county(county)
    end
  end
end
