defmodule EtWeb.PerishableController do
  use EtWeb, :controller

  alias Et.Perishables

  action_fallback EtWeb.FallbackController

  plug(
    Loaders,
    :perishable
    when action in [:show, :delete, :update]
  )

  @spec open_api_operation(atom) :: Operation.t()
  def open_api_operation(action) do
    operation = String.to_existing_atom("#{action}_operation")
    apply(__MODULE__, operation, [])
  end

  @spec show_operation() :: Operation.t()
  def show_operation do
    %Operation{
      tags: ["Perishable"],
      summary: "Get perishable by ID",
      description: "Extract details of a perishable",
      operationId: "PerishableController.show",
      parameters: [
        Operation.parameter(
          :perishable_id,
          :path,
          %Schema{type: :string, format: :uuid},
          "Perishable ID",
          required: true
        )
      ],
      responses: %{}
    }
  end

  def show(%{assigns: %{perishable: perishable}} = conn, _params),
    do: render(conn, "show.json", perishable: perishable)

  @spec index_operation() :: Operation.t()
  def index_operation do
    %Operation{
      tags: ["Perishable"],
      summary: "Query perishables",
      description: "Find an perishable",
      operationId: "PerishableController.index",
      parameters: [],
      responses: %{}
    }
  end

  def index(conn, params) do
    with {:ok, perishables} <- Perishables.all_perishables(params, []) do
      render(conn, "index.json", perishables: perishables)
    end
  end

  @spec create_operation() :: Operation.t()
  def create_operation do
    %Operation{
      tags: ["Perishable"],
      summary: "Create an perishable",
      description: "",
      operationId: "PerishableController.create",
      parameters: [],
      requestBody:
        Operation.request_body("Perishable attributes", "application/json", %Schema{
          type: :object,
          properties: %{}
        }),
      responses: Errors.default_error_responses()
    }
  end

  def create(conn, params) do
    with {:ok, perishable} <- Perishables.create_perishable(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.perishable_path(conn, :show, perishable))
      |> render("show.json", perishable: perishable)
    end
  end

  @spec update_operation() :: Operation.t()
  def update_operation do
    %Operation{
      tags: ["Perishable"],
      summary: "Update an perishable's details",
      description: "Update an perishable's details",
      operationId: "PerishableController.update",
      parameters: [
        Operation.parameter(
          :perishable_id,
          :path,
          %Schema{type: :string, format: :uuid},
          "Perishable ID",
          required: true
        )
      ],
      requestBody:
        Operation.request_body("Perishable details", "application/json", %Schema{
          type: :object,
          properties: %{
          }
        }),
      responses: %{}
    }
  end

  def update(%{assigns: %{perishable: perishable}} = conn, params) do
    params = Map.take(params, ["first_name", "last_name"])

    with {:ok, perishable} <- Perishables.update_perishable(perishable, params) do
      render(conn, "show.json", perishable: perishable)
    end
  end

  @spec delete_operation() :: Operation.t()
  def delete_operation do
    %Operation{
      tags: ["Perishable"],
      summary: "Delete an existing perishable",
      description: "",
      operationId: "PerishableController.delete",
      parameters: [
        Operation.parameter(
          :perishable_id,
          :path,
          %Schema{type: :string, format: :uuid},
          "Perishable ID",
          required: true
        )
      ],
      responses: Errors.default_error_responses()
    }
  end

  def delete(%{assigns: %{perishable: perishable}} = conn, _params) do
    case Perishables.delete_perishable(perishable) do
      {:ok, _} ->
        send_resp(conn, :no_content, "")

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
