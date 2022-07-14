defmodule Et.Perishables.Schemas.Entry do
  use Et, :model

  @primary_key {:entry_id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :entry_id}

  schema "entry" do
    field(:expiry, :utc_datetime_usec)

    belongs_to(:perishable, Et.Perishables.Schemas.Perishable,
      references: :perishable_id,
      foreign_key: :perishable_id
    )

    timestamps(type: :utc_datetime_usec)
  end

  @required_attrs [
    :perishable_id,
  ]

  @optional_attrs [
    :expiry
  ]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_attrs ++ @optional_attrs)
    |> validate_required(@required_attrs)
  end
end
