defmodule BlitzWeb.RoomLive.Game.CurrentRoundComponent do
  use BlitzWeb, :live_component
  alias Blitz.Rooms

  @impl true
  def render(assigns) do
    ~H"""
      <div style='display: grid; grid-template-columns: 15% 15% 15% 15% 15%;'>
        <div>Player</div>
        <div>Blitz Count</div>
        <div>Hand Count</div>
        <div>Score</div>
        <div>Total Score</div>
        <%= for user <- prep_users(@users, @rounds) do %>
          <% score = Enum.find(List.first(@rounds).scores, fn score -> score.user_id == user.id end) %>

          <div><%= user.name %></div>
          <div><%= score && score.blitz_count || '_' %></div>
          <div><%= score && score.hand_count || '_' %></div>
          <div><%= score && Rooms.calculate_score(score.blitz_count, score.hand_count) || '_' %></div>
          <div><%= user.total_score %></div>
        <% end %>
      </div>
    """
  end

  defp calculate_total_score(user, rounds) do
    scores = Enum.map(rounds, fn round ->
      score = Enum.find(round.scores, fn score -> score.user_id == user.id end)

      score && Rooms.calculate_score(score.blitz_count, score.hand_count) || 0
    end)

    Enum.sum(scores)
  end

  defp prep_users(users, rounds) do
    users_with_total = Enum.map(users, fn user ->
      Map.put(user, :total_score, calculate_total_score(user, rounds))
    end)

    Enum.sort_by(users_with_total, fn user -> -user.total_score end)
  end
end
