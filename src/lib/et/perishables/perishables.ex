defmodule Et.Perishables.Perishables do
  use Et, :query
  use Et, :mutation

  alias Et.Repo
  alias Et.Perishables.Schemas.Perishable

  def all_perishables(params \\ %{}, preload \\ []) do
    results =
      params
      |> query_all_perishables(preload)
      |> Repo.all()

    {:ok, results}
  end

  def find_perishable(params, preload \\ [])

  def find_perishable(params, preload) when map_size(params) > 0 do
    query = query_all_perishables(params, preload)

    case Repo.one(query) do
      nil -> {:error, :not_found}
      perishable -> {:ok, perishable}
    end
  end

  def find_perishable(_params, _preload), do: {:error, :invalid_params}

  def create_perishable(params \\ %{}) do
    %Perishable{}
    |> Perishable.changeset(params)
    |> Repo.insert()
  end

  def update_perishable(%Perishable{} = perishable, params \\ %{}) do
    perishable
    |> Perishable.changeset(params)
    |> Repo.update()
  end

  def delete_perishable(%Perishable{} = perishable),
    do: Repo.delete(perishable)

  defp query_all_perishables(params, preload) do
    Perishable
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
      {"perishable_id", id}, dynamic ->
        dynamic([pa], ^dynamic and pa.perishable_id == ^id)

      {"category_id", id}, dynamic ->
        dynamic([pa], ^dynamic and pa.perishable_id == ^id)

      {"name", name}, dynamic ->
        dynamic([pa], ^dynamic and pa.name == ^name)

      _, dynamic ->
        dynamic
    end)
  end
end
