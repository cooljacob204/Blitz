defmodule Blitz.Games.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blitz.Games.User

  schema "rooms" do
    field :state, :string, default: "lobby"

    has_many :users, User

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:state])
    |> validate_required([:state])
    |> validate_inclusion(
      :state,
      ~w(lobby game)
    )
  end
end
