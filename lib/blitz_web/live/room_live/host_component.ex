defmodule BlitzWeb.RoomLive.HostComponent do
  use BlitzWeb, :live_component

  alias Blitz.Lobbies

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
    room = Lobbies.get_room!(socket.assigns.room.id)
    Lobbies.update_room(room, %{state: "game"})
    Lobbies.create_round( %{"room_id" => room.id})

    {:noreply,
     socket}
  end
end
