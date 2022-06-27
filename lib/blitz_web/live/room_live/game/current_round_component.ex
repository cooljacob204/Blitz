defmodule BlitzWeb.RoomLive.Game.CurrentRoundComponent do
  use BlitzWeb, :live_component
  alias Blitz.Rooms

  @impl true
  def render(assigns) do
    ~H"""
      <div style='display: grid; grid-template-columns: 10% 10% 10% 10%;'>
        <%= for user <- @users do %>
          <% score = Enum.find(@scores, fn score -> score.user_id == user.id end) %>

          <div><%= user.name %></div>
          <div><%= score && score.blitz_count %></div>
          <div><%= score && score.hand_count %></div>
          <div><%= score && Rooms.calculate_score(score.blitz_count, score.hand_count) %></div>
        <% end %>
      </div>
    """
  end
end
