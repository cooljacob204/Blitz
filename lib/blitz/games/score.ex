defmodule Blitz.Rooms.Score do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blitz.Rooms.Round
  alias Blitz.Rooms.User

  schema "scores" do
    belongs_to :round, Round
    belongs_to :user, User
    field :blitz_count, :integer
    field :hand_count, :integer

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:user_id, :round_id, :blitz_count, :hand_count])
    |> validate_required([:user_id, :round_id, :blitz_count, :hand_count])
    |> validate_number(:blitz_count, greater_than_or_equal_to: 0, less_than_or_equal_to: 10)
    |> validate_number(:hand_count, greater_than_or_equal_to: 0, less_than_or_equal_to: 40)
  end
end
