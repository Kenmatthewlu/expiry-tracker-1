defmodule EtWeb.PerishableLoaders do
  alias Et.Perishables

  def resource(_conn, :perishable, %{"perishable_id" => id}) do
    case Perishables.find_perishable(%{"perishable_id" => id}) do
      {:ok, perishable} -> {:ok, :perishable, perishable}
      {:error, _message} -> {:error, :perishable}
    end
  end

  def resource(_conn, :entry, %{"entry_id" => id}) do
    case Perishables.find_entry(%{"entry_id" => id}) do
      {:ok, entry} -> {:ok, :entry, entry}
      {:error, _message} -> {:error, :entry}
    end
  end
end
