defmodule BlitzWeb.RoomLive.Game do
  use BlitzWeb, :live_view
  alias Blitz.Rooms

  def mount(_params, %{"user_id" => user_id, "room_id" => room_id}, socket) do
    user = Rooms.get_user!(user_id)
    room = Rooms.get_room!(room_id)
    users = Rooms.list_users(room)
    rounds = Rooms.list_rounds(room)
    scores = Rooms.list_scores(List.first(rounds))

    if connected?(socket), do: Rooms.subscribe_game(room)

    {:ok,
      socket
      |> assign(:user, user)
      |> assign(:room, room)
      |> assign(:users, users)
      |> assign(rounds: rounds)
      |> assign(scores: scores)}
  end

  def handle_info({:score_created, score}, socket) do
    {:noreply,
      update(socket, :scores, fn scores -> [score | scores] end)}
  end
end
