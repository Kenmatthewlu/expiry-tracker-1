defmodule Et.Perishables do
  alias Et.Perishables.Perishables
  alias Et.Perishables.Entries

  def all_perishables(params \\ %{}, preload \\ []), do: Perishables.all_perishables(params, preload)
  def find_perishable(params, preload \\ []), do: Perishables.find_perishable(params, preload)
  def create_perishable(params \\ %{}), do: Perishables.create_perishable(params)
  def update_perishable(perishable, params \\ %{}), do: Perishables.update_perishable(perishable, params)
  def delete_perishable(perishable), do: Perishables.delete_perishable(perishable)

  def all_entries(params \\ %{}, preload \\ []), do: Entries.all_entries(params, preload)
  def find_entry(params, preload \\ []), do: Entries.find_entry(params, preload)
  def create_entry(params \\ %{}), do: Entries.create_entry(params)
  def update_entry(entry, params \\ %{}), do: Entries.update_entry(entry, params)
  def delete_entry(entry), do: Entries.delete_entry(entry)
end
