defmodule Blitz.Games.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blitz.Games.Room

  schema "users" do
    field :name, :string

    belongs_to :room, Room
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :room_id])
    |> unique_constraint([:name, :room_id])
    |> validate_required([:name, :room_id])
  end
end
