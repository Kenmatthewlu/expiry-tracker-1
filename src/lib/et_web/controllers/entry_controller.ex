defmodule EtWeb.EntryController do
  use EtWeb, :controller

  alias Et.Perishables

  action_fallback EtWeb.FallbackController

  plug(
    Loaders,
    :entry
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
      tags: ["Entry"],
      summary: "Get entry by ID",
      description: "Extract details of a entry",
      operationId: "EntryController.show",
      parameters: [
        Operation.parameter(
          :entry_id,
          :path,
          %Schema{type: :string, format: :uuid},
          "Entry ID",
          required: true
        )
      ],
      responses: %{}
    }
  end

  def show(%{assigns: %{entry: entry}} = conn, _params),
    do: render(conn, "show.json", entry: entry)

  @spec index_operation() :: Operation.t()
  def index_operation do
    %Operation{
      tags: ["Entry"],
      summary: "Query entries",
      description: "Find an entry",
      operationId: "EntryController.index",
      parameters: [],
      responses: %{}
    }
  end

  def index(conn, params) do
    with {:ok, entries} <- Perishables.all_entries(params, []) do
      render(conn, "index.json", entries: entries)
    end
  end

  @spec create_operation() :: Operation.t()
  def create_operation do
    %Operation{
      tags: ["Entry"],
      summary: "Create an entry",
      description: "",
      operationId: "EntryController.create",
      parameters: [],
      requestBody:
        Operation.request_body("Entry attributes", "application/json", %Schema{
          type: :object,
          properties: %{}
        }),
      responses: Errors.default_error_responses()
    }
  end

  def create(conn, params) do
    with {:ok, entry} <- Perishables.create_entry(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.entry_path(conn, :show, entry))
      |> render("show.json", entry: entry)
    end
  end

  @spec update_operation() :: Operation.t()
  def update_operation do
    %Operation{
      tags: ["Entry"],
      summary: "Update an entry's details",
      description: "Update an entry's details",
      operationId: "EntryController.update",
      parameters: [
        Operation.parameter(
          :entry_id,
          :path,
          %Schema{type: :string, format: :uuid},
          "Entry ID",
          required: true
        )
      ],
      requestBody:
        Operation.request_body("Entry details", "application/json", %Schema{
          type: :object,
          properties: %{
          }
        }),
      responses: %{}
    }
  end

  def update(%{assigns: %{entry: entry}} = conn, params) do
    params = Map.take(params, ["first_name", "last_name"])

    with {:ok, entry} <- Perishables.update_entry(entry, params) do
      render(conn, "show.json", entry: entry)
    end
  end

  @spec delete_operation() :: Operation.t()
  def delete_operation do
    %Operation{
      tags: ["Entry"],
      summary: "Delete an existing entry",
      description: "",
      operationId: "EntryController.delete",
      parameters: [
        Operation.parameter(
          :entry_id,
          :path,
          %Schema{type: :string, format: :uuid},
          "Entry ID",
          required: true
        )
      ],
      responses: Errors.default_error_responses()
    }
  end

  def delete(%{assigns: %{entry: entry}} = conn, _params) do
    case Perishables.delete_entry(entry) do
      {:ok, _} ->
        send_resp(conn, :no_content, "")

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
