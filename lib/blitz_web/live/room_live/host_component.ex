defmodule BlitzWeb.RoomLive.HostComponent do
  use BlitzWeb, :live_component

  alias Blitz.Games

  def render(assigns) do
    ~H"""
      <div>
        <%= if @room.state == "lobby" do %>
          <button phx-click="start_game" phx-target={@myself}>Start Game</button>
        <% end %>
      </div>
    """
  end

  def handle_event("start_game", _value, socket) do
    room = Games.get_room!(socket.assigns.room.id)
    Games.update_room(room, %{state: "game"})
    Games.create_round( %{"room_id" => room.id})

    {:noreply,
     socket}
  end
end
