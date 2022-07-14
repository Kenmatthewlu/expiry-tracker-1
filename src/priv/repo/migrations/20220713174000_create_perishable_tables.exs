defmodule Et.Repo.Migrations.CreatePerishableTables do
  use Ecto.Migration

  def change do
    create table(:perishable, primary_key: false) do
      add(:perishable_id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()"))
      add(:name, :string, null: false)
      add(:shelf_life, :integer, null: false)
      add(:category_id, references(:category, column: :category_id, type: :uuid),
        null: false
      )
      timestamps(type: :timestamptz)
    end

    create table(:entry, primary_key: false) do
      add(:entry_id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()"))
      add(:perishable_id, references(:perishable, column: :perishable_id, type: :uuid),
        null: false
      )
      add(:expiry, :timestamptz)
      timestamps(type: :timestamptz)
    end

    create(unique_index(:perishable, [:name]))
  end
end
