defmodule Blitz.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blitz.Games` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{

      })
      |> Blitz.Games.create_room()

    room
  end
end
