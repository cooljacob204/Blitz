defmodule BlitzWeb.RoomLive.UserComponent do
  use BlitzWeb, :live_component

  def render(assigns) do
    ~H"""
      <div id={"user-#{@user.id}"}>
        <div class="column">
          <%= @user.name %>
        </div>
      </div>
    """
  end
end
