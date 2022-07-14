defmodule EtWeb.CategoryView do
  use EtWeb, :view
  alias EtWeb.CategoryView

  def render("index.json", %{categories: categories}) do
    render_many(categories, CategoryView, "category.json")
  end

  def render("show.json", %{category: category}) do
    render_one(category, CategoryView, "category.json")
  end

  def render("category.json", %{category: category}) do
    category
    |> Map.take([
      :category_id,
      :name,
      :inserted_at,
      :updated_at,
    ])
  end
end
