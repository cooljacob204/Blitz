defmodule BlitzWeb.RoomLive.Game.CurrentRoundComponent do
  use BlitzWeb, :live_component
  alias Blitz.Rooms

  @impl true
  def render(assigns) do
    ~H"""
      <div style='display: grid; grid-template-columns: 15% 15% 15% 15%;'>
        <div>Player</div>
        <div>Blitz Count</div>
        <div>Hand Count</div>
        <div>Score</div>
        <%= for user <- @users do %>
          <% score = Enum.find(@round.scores, fn score -> score.user_id == user.id end) %>

          <div><%= user.name %></div>
          <div><%= score && score.blitz_count || '_' %></div>
          <div><%= score && score.hand_count || '_' %></div>
          <div><%= score && Rooms.calculate_score(score.blitz_count, score.hand_count) || '_' %></div>
        <% end %>
      </div>
    """
  end
end
