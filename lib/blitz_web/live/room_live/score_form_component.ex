defmodule BlitzWeb.RoomLive.ScoreFormComponent do
  use BlitzWeb, :live_component
  alias Blitz.Rooms
  alias Blitz.Rooms.Score

  def render(assigns) do
    ~H"""
      <div>
        <%= if @score do %>
          <%= @score.blitz_count %>
          <%= @score.hand_count %>
        <% else %>
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

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_score_changeset()
     |> assign(score: nil)}
  end

  def assign_score_changeset(socket) do
    assign(socket, :score_changeset, Score.changeset(%Score{}, %{}))
  end

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
    {:noreply,
      socket
      |> assign(score: score )
      |> assign(score_changeset: nil )}
  end
  defp score_created({:error, changeset}, socket) do
    {:noreply,
      socket
      |> assign(score_changeset: changeset )}
  end
end
