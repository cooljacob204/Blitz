defmodule Blitz.LobbiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blitz.Lobbies` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{

      })
      |> Blitz.Lobbies.create_room()

    room
  end
end
