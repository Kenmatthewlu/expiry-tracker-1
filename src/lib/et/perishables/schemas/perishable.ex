defmodule Et.Perishables.Schemas.Perishable do
  use Et, :model

  @primary_key {:perishable_id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :perishable_id}

  schema "perishable" do
    field(:name, :string)
    field(:shelf_life, :integer)

    belongs_to(:category, Et.Perishables.Schemas.Perishable,
      references: :category_id,
      foreign_key: :category_id
    )

    has_many(:entries, Et.Perishables.Schemas.Entry,
      foreign_key: :entry_id,
      on_replace: :delete
    )

    timestamps(type: :utc_datetime_usec)
  end

  @required_attrs [
    :name,
    :shelf_life
  ]

  @optional_attrs [
    :category_id
  ]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_attrs ++ @optional_attrs)
    |> validate_required(@required_attrs)
  end
end
