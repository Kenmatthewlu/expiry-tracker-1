defmodule Et do
  @moduledoc """
  Et keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Ecto.Changeset
  alias Ecto.Multi
  alias Ecto.Query
  alias Ecto.Schema

  def model do
    quote do
      use Schema
      import Changeset

      @foreign_key_type :binary_id
    end
  end

  def query do
    quote do
      import Query
    end
  end

  def mutation do
    quote do
      alias Multi
      import Changeset
    end
  end

  def resolver do
    quote do
      alias Et.Repo
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
