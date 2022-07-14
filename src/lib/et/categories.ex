defmodule Et.Categories do
  alias Et.Categories.Categories

  def all_categories(params \\ %{}, preload \\ []), do: Categories.all_categories(params, preload)
  def find_category(params, preload \\ []), do: Categories.find_category(params, preload)
  def create_category(params \\ %{}), do: Categories.create_category(params)
  def update_category(category, params \\ %{}), do: Categories.update_category(category, params)
  def delete_category(category), do: Categories.delete_category(category)
end
