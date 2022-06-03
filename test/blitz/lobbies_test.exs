defmodule Blitz.LobbiesTest do
  use Blitz.DataCase

  alias Blitz.Lobbies

  describe "rooms" do
    alias Blitz.Lobbies.Room

    import Blitz.LobbiesFixtures

    @invalid_attrs %{}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Lobbies.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Lobbies.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{}

      assert {:ok, %Room{} = room} = Lobbies.create_room(valid_attrs)
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lobbies.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{}

      assert {:ok, %Room{} = room} = Lobbies.update_room(room, update_attrs)
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Lobbies.update_room(room, @invalid_attrs)
      assert room == Lobbies.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Lobbies.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Lobbies.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Lobbies.change_room(room)
    end
  end
end
