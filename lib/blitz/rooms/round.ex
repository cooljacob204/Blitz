defmodule Blitz.Rooms.Round do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blitz.Rooms.Room
  alias Blitz.Rooms.Score

  schema "rounds" do
    belongs_to :room, Room
    has_many :scores, Score

    timestamps()
  end

  @doc false
  def changeset(round, attrs) do
    round
    |> cast(attrs, [:room_id])
    |> validate_required([:room_id])
  end
end
