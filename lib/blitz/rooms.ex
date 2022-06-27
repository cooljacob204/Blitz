defmodule Blitz.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.Query, warn: false
  alias Blitz.Repo

  alias Blitz.Rooms.Room
  alias Blitz.Rooms.User
  alias Blitz.Rooms.Round
  alias Blitz.Rooms.Score

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  def list_users(room) do
    query =
      from p in User,
      order_by: [desc: p.inserted_at],
      where: p.room_id == ^room.id

    Repo.all(query)
  end

  def list_scores(round) do
    query =
      from p in Score,
      order_by: [desc: p.inserted_at],
      where: p.round_id == ^round.id

    Repo.all(query)
  end

  def list_rounds(room) do
    query =
      from p in Round,
      order_by: [desc: p.inserted_at],
      where: p.room_id == ^room.id

    Repo.all(query)
  end

  def get_room!(id), do: Repo.get!(Room, id)
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:user_created)
  end

  def create_round(attrs \\ %{}) do
    %Round{}
    |> Round.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:round_created)
  end

  def create_score(attrs \\ %{}) do
    %Score{}
    |> Score.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:score_created)
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
    |> broadcast(:room_updated)
  end

  @doc """
  Deletes a room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def change_score(%Score{} = score, attrs \\ %{}) do
    Score.changeset(score, attrs)
  end

  def subscribe(%Room{} = room) do
    Phoenix.PubSub.subscribe(Blitz.PubSub, "room-#{room.id}")
  end

  def subscribe_game(%Room{} = room) do
    Phoenix.PubSub.subscribe(Blitz.PubSub, "room-#{room.id}-game")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, %User{} = user}, event) do
    Phoenix.PubSub.broadcast(Blitz.PubSub, "room-#{user.room_id}", {event, user})

    {:ok, user}
  end
  defp broadcast({:ok, %Room{} = room}, event) do
    Phoenix.PubSub.broadcast(Blitz.PubSub, "room-#{room.id}", {event, room})

    {:ok, room}
  end
  defp broadcast({:ok, %Round{} = round}, event) do
    Phoenix.PubSub.broadcast(Blitz.PubSub, "room-#{round.room_id}-game", {event, round})

    {:ok, round}
  end
  defp broadcast({:ok, %Score{} = score}, event) do
    round = Repo.get(Round, score.round_id)
    Phoenix.PubSub.broadcast(Blitz.PubSub, "room-#{round.room_id}-game", {event, score})

    {:ok, score}
  end
end
