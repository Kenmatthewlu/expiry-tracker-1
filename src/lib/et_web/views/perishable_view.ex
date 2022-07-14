defmodule EtWeb.PerishableView do
  use EtWeb, :view
  alias EtWeb.PerishableView

  def render("index.json", %{perishables: perishables}) do
    render_many(perishables, PerishableView, "perishable.json")
  end

  def render("show.json", %{perishable: perishable}) do
    render_one(perishable, PerishableView, "perishable.json")
  end

  def render("perishable.json", %{perishable: perishable}) do
    perishable
    |> Map.take([
      :perishable_id,
      :shelf_life,
      :category_id,
      :name,
      :inserted_at,
      :updated_at,
    ])
  end
end
