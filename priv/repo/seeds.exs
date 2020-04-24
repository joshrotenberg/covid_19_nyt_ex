alias Covid19.Repo
alias Covid19.Data.ZipCode

"zip2fips.json"
|> Path.absname("./priv/repo/seeds/zip")
|> Path.expand()
|> File.read!()
|> Jason.decode!()
|> Enum.each(fn item ->
  %ZipCode{}
  |> ZipCode.changeset(%{
    zip: elem(item, 0),
    fips: elem(item, 1)
  })
  |> Repo.insert!(on_conflict: :nothing)
end)
