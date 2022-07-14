defmodule Et.Perishables.Entries do
  use Et, :query
  use Et, :mutation

  alias Et.Repo
  alias Et.Perishables.Schemas.Entry

  def all_entries(params \\ %{}, preload \\ []) do
    results =
      params
      |> query_all_entries(preload)
      |> Repo.all()

    {:ok, results}
  end

  def find_entry(params, preload \\ [])

  def find_entry(params, preload) when map_size(params) > 0 do
    query = query_all_entries(params, preload)

    case Repo.one(query) do
      nil -> {:error, :not_found}
      entry -> {:ok, entry}
    end
  end

  def find_entry(_params, _preload), do: {:error, :invalid_params}

  def create_entry(params \\ %{}) do
    %Entry{}
    |> Entry.changeset(params)
    |> Repo.insert()
  end

  def update_entry(%Entry{} = entry, params \\ %{}) do
    entry
    |> Entry.changeset(params)
    |> Repo.update()
  end

  def delete_entry(%Entry{} = entry),
    do: Repo.delete(entry)

  defp query_all_entries(params, preload) do
    Entry
    |> from(as: :entry)
    |> preload(^preload)
    |> order_by(^filter_order_by(params))
    |> where(^filter_where(params))
  end

  defp filter_order_by(%{"sort" => "insert_desc"}),
    do: [desc: dynamic([p], p.inserted_at)]

  defp filter_order_by(%{"sort" => "insert_asc"}),
    do: [asc: dynamic([p], p.inserted_at)]

  defp filter_order_by(_),
    do: [desc: dynamic([pa], pa.inserted_at)]

  defp filter_where(params) do
    Enum.reduce(params, dynamic(true), fn
      {"entry_id", id}, dynamic ->
        dynamic([e], ^dynamic and e.entry_id == ^id)

      {"perishable_id", id}, dynamic ->
        dynamic([e], ^dynamic and e.perishable_id == ^id)

        # date range for expiry

      _, dynamic ->
        dynamic
    end)
  end
end
