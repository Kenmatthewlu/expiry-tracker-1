defmodule EtWeb.EntryView do
  use EtWeb, :view
  alias EtWeb.EntryView

  def render("index.json", %{entries: entries}) do
    render_many(entries, EntryView, "entry.json")
  end

  def render("show.json", %{entry: entry}) do
    render_one(entry, EntryView, "entry.json")
  end

  def render("entry.json", %{entry: entry}) do
    entry
    |> Map.take([
      :entry_id,
      :perishable_id,
      :expiry,
      :inserted_at,
      :updated_at,
    ])
  end
end
