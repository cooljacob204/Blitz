defmodule Blitz.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blitz.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{

      })
      |> Blitz.Rooms.create_room()

    room
  end
end
