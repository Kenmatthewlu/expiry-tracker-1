defmodule EtWeb.CategoryLoaders do
  alias Et.Categories

  def resource(_conn, :category, %{"category_id" => id}) do
    case Categories.find_category(%{"category_id" => id}) do
      {:ok, category} -> {:ok, :category, category}
      {:error, _message} -> {:error, :category}
    end
  end
end
