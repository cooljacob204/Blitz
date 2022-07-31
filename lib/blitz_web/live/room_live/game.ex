defmodule BlitzWeb.RoomLive.Game do
  use BlitzWeb, :live_view
  alias Blitz.Rooms

  def mount(_params, %{"user_id" => user_id, "room_id" => room_id}, socket) do
    user = Rooms.get_user!(user_id)
    room = Rooms.get_room!(room_id)
    users = Rooms.list_users(room)
    rounds = Rooms.list_rounds(room)

    if connected?(socket), do: Rooms.subscribe_game(room)

    {:ok,
      socket
      |> assign(:user, user)
      |> assign(:room, room)
      |> assign(:users, users)
      |> assign(:rounds, rounds)
      |> assign(:winner, nil)}
  end

  def handle_info({:score_created, score}, socket) do
    [head | tail] = socket.assigns.rounds
    round = %{head | scores: [score | head.scores]}

    {:noreply,
      assign(socket, :rounds, [round | tail])}
  end
  def handle_info({:round_created, round}, socket) do
    Process.send_after(self(), :remove_winner, 4000)
    prev_round = List.first(socket.assigns.rounds)
    winning_score = Enum.max_by(prev_round.scores, fn score -> Rooms.calculate_score(score.blitz_count, score.hand_count) end)
    winner = Enum.find(socket.assigns.users, fn user -> user.id == winning_score.user_id end)

    {:noreply,
      socket
      |> assign(:winner, winner)
      |> update(:rounds, fn rounds -> [round | rounds] end)}
  end
  def handle_info(:remove_winner, socket) do
    {:noreply, assign(socket, :winner, nil)}
  end
end
