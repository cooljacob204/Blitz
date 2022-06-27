defmodule Blitz.Games.Round do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blitz.Games.Room
  alias Blitz.Games.Score

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
