defmodule EtWeb.CategoryController do
  use EtWeb, :controller

  alias Et.Categories

  action_fallback EtWeb.FallbackController

  plug(
    Loaders,
    :category
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
      tags: ["Category"],
      summary: "Get category by ID",
      description: "Extract details of a category",
      operationId: "CategoryController.show",
      parameters: [
        Operation.parameter(
          :category_id,
          :path,
          %Schema{type: :string, format: :uuid},
          "Category ID",
          required: true
        )
      ],
      responses: %{}
    }
  end

  def show(%{assigns: %{category: category}} = conn, _params),
    do: render(conn, "show.json", category: category)

  @spec index_operation() :: Operation.t()
  def index_operation do
    %Operation{
      tags: ["Category"],
      summary: "Query categories",
      description: "Find a category",
      operationId: "CategoryController.index",
      parameters: [],
      responses: %{}
    }
  end

  def index(conn, params) do
    with {:ok, categories} <- Categories.all_categories(params, []) do
      render(conn, "index.json", categories: categories)
    end
  end

  @spec create_operation() :: Operation.t()
  def create_operation do
    %Operation{
      tags: ["Category"],
      summary: "Create a category",
      description: "",
      operationId: "CategoryController.create",
      parameters: [],
      requestBody:
        Operation.request_body("Category attributes", "application/json", %Schema{
          type: :object,
          properties: %{}
        }),
      responses: Errors.default_error_responses()
    }
  end

  def create(conn, params) do
    with {:ok, category} <- Categories.create_category(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.category_path(conn, :show, category))
      |> render("show.json", category: category)
    end
  end

  @spec update_operation() :: Operation.t()
  def update_operation do
    %Operation{
      tags: ["Category"],
      summary: "Update a category's details",
      description: "Update a category's details",
      operationId: "CategoryController.update",
      parameters: [
        Operation.parameter(
          :category_id,
          :path,
          %Schema{type: :string, format: :uuid},
          "Category ID",
          required: true
        )
      ],
      requestBody:
        Operation.request_body("Category details", "application/json", %Schema{
          type: :object,
          properties: %{
            name: %Schema{type: :string}
          }
        }),
      responses: %{}
    }
  end

  def update(%{assigns: %{category: category}} = conn, params) do
    params = Map.take(params, ["first_name", "last_name"])

    with {:ok, category} <- Categories.update_category(category, params) do
      render(conn, "show.json", category: category)
    end
  end

  @spec delete_operation() :: Operation.t()
  def delete_operation do
    %Operation{
      tags: ["Category"],
      summary: "Delete an existing category",
      description: "",
      operationId: "CategoryController.delete",
      parameters: [
        Operation.parameter(
          :category_id,
          :path,
          %Schema{type: :string, format: :uuid},
          "Category ID",
          required: true
        )
      ],
      responses: Errors.default_error_responses()
    }
  end

  def delete(%{assigns: %{category: category}} = conn, _params) do
    case Categories.delete_category(category) do
      {:ok, _} ->
        send_resp(conn, :no_content, "")

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
