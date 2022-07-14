defmodule EtWeb.Loaders do
  use PolicyWonk.Load
  use PolicyWonk.Resource
  use Phoenix.Controller

  alias EtWeb.ErrorView
  alias EtWeb.CategoryLoaders
  alias EtWeb.PerishableLoaders

  def resource(conn, resource, params)
      when resource in [:category],
      do: CategoryLoaders.resource(conn, resource, params)

  def resource(conn, resource, params)
      when resource in [:perishable, :entry],
      do: PerishableLoaders.resource(conn, resource, params)

  def resource(conn, _resource, _params), do: resource_error(conn, nil)

  def resource_error(conn, _resource_id) do
    resource_not_found(conn)
  end

  defp resource_not_found(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render(:"404")
    |> halt()
  end
end
