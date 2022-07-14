defmodule Et.Categories.Categories do
  use Et, :query
  use Et, :mutation

  alias Et.Repo
  alias Et.Categories.Schemas.Category

  def all_categories(params \\ %{}, preload \\ []) do
    results =
      params
      |> query_all_categories(preload)
      |> Repo.all()

    {:ok, results}
  end

  def find_category(params, preload \\ [])

  def find_category(params, preload) when map_size(params) > 0 do
    query = query_all_categories(params, preload)

    case Repo.one(query) do
      nil -> {:error, :not_found}
      category -> {:ok, category}
    end
  end

  def find_category(_params, _preload), do: {:error, :invalid_params}

  def create_category(params \\ %{}) do
    %Category{}
    |> Category.changeset(params)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, params \\ %{}) do
    category
    |> Category.changeset(params)
    |> Repo.update()
  end

  def delete_category(%Category{} = category),
    do: Repo.delete(category)

  defp query_all_categories(params, preload) do
    Category
    |> from(as: :category)
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
      {"category_id", id}, dynamic ->
        dynamic([e], ^dynamic and e.category_id == ^id)

      {"name", name}, dynamic ->
        dynamic([e], ^dynamic and e.name == ^name)

      _, dynamic ->
        dynamic
    end)
  end
end
