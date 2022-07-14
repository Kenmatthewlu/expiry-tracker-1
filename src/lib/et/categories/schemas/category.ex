defmodule Et.Categories.Schemas.Category do
  use Et, :model

  @primary_key {:category_id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :category_id}

  schema "category" do
    field(:name, :string)

    has_many(:perishables, Et.Perishables.Schemas.Perishable,
      foreign_key: :perishable_id,
      on_replace: :delete
    )

    timestamps(type: :utc_datetime_usec)
  end

  @required_attrs [
    :name
  ]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_attrs)
    |> validate_required(@required_attrs)
  end
end
