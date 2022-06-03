defmodule BlitzWeb.RoomController do
  use BlitzWeb, :controller

  alias Blitz.Lobbies
  alias Blitz.Lobbies.Room

  def index(conn, _params) do
    rooms = Lobbies.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params) do
    changeset = Lobbies.change_room(%Room{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    case Lobbies.create_room(room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room created successfully.")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Lobbies.get_room!(id)
    render(conn, "show.html", room: room)
  end

  def edit(conn, %{"id" => id}) do
    room = Lobbies.get_room!(id)
    changeset = Lobbies.change_room(room)
    render(conn, "edit.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Lobbies.get_room!(id)

    case Lobbies.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: Routes.room_path(conn, :show, room))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Lobbies.get_room!(id)
    {:ok, _room} = Lobbies.delete_room(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: Routes.room_path(conn, :index))
  end
end
