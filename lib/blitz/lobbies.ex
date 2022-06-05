defmodule Blitz.Lobbies do
  @moduledoc """
  The Lobbies context.
  """

  import Ecto.Query, warn: false
  alias Blitz.Repo

  alias Blitz.Lobbies.Room
  alias Blitz.Lobbies.User

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

  def get_room!(id), do: Repo.get!(Room, id)

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

  def subscribe(%Room{} = room) do
    Phoenix.PubSub.subscribe(Blitz.PubSub, "room-#{room.id}")
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
end
