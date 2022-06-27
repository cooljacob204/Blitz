defmodule BlitzWeb.RoomLive.Game.CurrentRoundComponent do
  use BlitzWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
      <div style='display: grid'>
        <%= for user <- @users do %>
          <% score = Enum.find(@scores, fn score -> score.user_id == user.id end) %>
          <%= user.name %>
          <%= score && score.blitz_score %>
          <%= score && score.hand_score %>
        <% end %>
      </div>
    """
  end
end