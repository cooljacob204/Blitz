defmodule Blitz.Lobbies.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blitz.Lobbies.User

  schema "rooms" do
    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [])
    |> validate_required([])
  end
end
