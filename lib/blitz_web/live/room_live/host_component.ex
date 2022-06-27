defmodule BlitzWeb.RoomLive.HostComponent do
  use BlitzWeb, :live_component

  alias Blitz.Rooms

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
    room = Rooms.get_room!(socket.assigns.room.id)
    Rooms.create_round( %{"room_id" => room.id})
    Rooms.update_room(room, %{state: "game"})

    {:noreply,
     socket}
  end
end
