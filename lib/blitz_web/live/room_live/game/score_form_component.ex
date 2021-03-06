defmodule BlitzWeb.RoomLive.Game.ScoreFormComponent do
  use BlitzWeb, :live_component
  alias Blitz.Rooms
  alias Blitz.Rooms.Score

  @impl true
  def render(assigns) do
    ~H"""
      <div>
        <%= unless @score do %>
          <.form
            let={f}
            for={@score_changeset}
            phx-change="validate_score"
            id="score-form"
            phx-submit="create_score"
            phx-target={@myself}>

            <%= label f, :blitz_count %>
            <%= text_input f, :blitz_count %>
            <%= error_tag f, :blitz_count %>

            <%= label f, :hand_count %>
            <%= text_input f, :hand_count %>
            <%= error_tag f, :hand_count %>

            <div>
              <%= submit "Submit", phx_disable_with: "Submitting..." %>
            </div>
          </.form>
        <% end %>
      </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign_score_changeset()
     |> assign(score: nil)}
  end

  @impl true
  def update(assigns, socket) do
    # unless Map.has_key?(assigns, :score), do: assign(socket, :score, Rooms.get_score(assigns.user.id, assigns.round.id))
    # assign(socket, :score, Rooms.get_score(assigns.user.id, assigns.round.id))
    socket = if Map.has_key?(assigns, :score) do
      socket
    else
      assign(socket, :score, Rooms.get_score(assigns.user.id, assigns.round.id))
    end

    {:ok,
     socket
     |> assign(assigns)}
  end

  def assign_score_changeset(socket) do
    assign(socket, :score_changeset, Score.changeset(%Score{}, %{}))
  end

  @impl true
  def handle_event("create_score", %{"score" => params},  %{assigns: %{user: user, round: round}} = socket) do
    score_created(Rooms.create_score(Map.merge(%{"round_id" => round.id, "user_id" => user.id}, params)), socket)
  end
  def handle_event("validate_score", %{"score" => params}, socket) do
    changeset =
      %Score{}
      |> Rooms.change_score(params)
      |> Map.put(:action, :insert)
    {:noreply,
     socket
     |> assign(score_changeset: changeset )}
  end

  defp score_created({:ok, score}, socket) do
    score_to_assign = if length(socket.assigns.round.scores) + 1 == length(socket.assigns.users) do
      Rooms.create_round(%{"room_id" => socket.assigns.room.id})
      nil
    else
      score
    end

    {:noreply,
      socket
      |> assign(score: score_to_assign)
      |> assign(score_changeset: Score.changeset(%Score{}, %{}))}
  end
  defp score_created({:error, changeset}, socket) do
    {:noreply,
      socket
      |> assign(score_changeset: changeset)}
  end
end
