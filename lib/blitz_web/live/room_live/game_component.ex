defmodule BlitzWeb.RoomLive.GameComponent do
  use BlitzWeb, :live_component
  alias Blitz.Rooms

  @impl true
  def render(assigns) do
    ~H"""
      <div>
        <.live_component module={BlitzWeb.RoomLive.Game.ScoreFormComponent} id="score-form" user={@user} room={@room} round={List.first(@rounds)}/>
        <.live_component module={BlitzWeb.RoomLive.Game.CurrentRoundComponent} id="current-round" users={@users} scores={@scores}/>
      </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    if Map.fetch(assigns, :room) != Map.fetch(socket.assigns, :room) do
      rounds = Rooms.list_rounds(assigns.room)
      scores = Rooms.list_scores(List.first(rounds))

      {:ok,
       socket
       |> assign(assigns)
       |> assign(rounds: rounds)
       |> assign(scores: scores)}
    else
      {:ok,
        socket
        |> assign(assigns)}
    end
  end

  def handle_info({:score_created, score}, socket) do
    {:noreply,
      update(socket, :score, fn scores -> [score | scores] end)}
  end
end
