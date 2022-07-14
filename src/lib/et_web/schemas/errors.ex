defmodule EtWeb.Schemas.Errors do
  require OpenApiSpex
  alias OpenApiSpex.{Operation, Schema}

  def schema(code, error \\ %{}) do
    %Schema{
      type: :object,
      properties: %{
        code: %Schema{
          type: :integer,
          minimum: 100,
          maximum: 600,
          example: code
        },
        errors: %Schema{type: :object, properties: error}
      }
    }
  end

  def unauthorized,
    do:
      Operation.response(
        "Unauthorized",
        "application/json",
        schema(402, %{detail: %Schema{type: :string, example: "Unauthorized"}})
      )

  def forbidden,
    do:
      Operation.response(
        "Forbidden",
        "application/json",
        schema(403, %{detail: %Schema{type: :string, example: "Forbidden"}})
      )

  def not_found do
    Operation.response(
      "Not Found",
      "application/json",
      schema(404, %{detail: %Schema{type: :string, example: "Not Found"}})
    )
  end

  def unprocessable_entity,
    do:
      Operation.response(
        "Unprocessable Entity",
        "application/json",
        schema(422, %{name: %Schema{type: :string, example: "can't be blank"}})
      )

  def internal_server_error,
    do:
      Operation.response(
        "Internal Server Error",
        "application/json",
        schema(500, %{
          detail: %Schema{type: :string, example: "Internal Server Error"}
        })
      )

  def default_error_responses,
    do: %{
      402 => unauthorized(),
      403 => forbidden(),
      500 => internal_server_error()
    }
end
