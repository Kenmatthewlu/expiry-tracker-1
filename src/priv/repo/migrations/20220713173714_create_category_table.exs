defmodule Et.Repo.Migrations.CreateCategoryTable do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\" WITH SCHEMA public;")

    create table(:category, primary_key: false) do
      add(:category_id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()"))
      add(:name, :string, null: false)

      timestamps(type: :timestamptz)
    end

    create(unique_index(:category, [:name]))
  end
end
