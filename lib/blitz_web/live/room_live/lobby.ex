defmodule BlitzWeb.RoomLive.Lobby do
  use BlitzWeb, :live_component

  def render(assigns) do
    ~H"""
      <div>
        <h2>Users</h2>
        <div>
          <%= for user <- Enum.reverse(@users) do %>
            <%= live_component BlitzWeb.RoomLive.UserComponent, id: user.id, user: user %>
          <% end %>
        </div>
      </div>
    """
  end
end
