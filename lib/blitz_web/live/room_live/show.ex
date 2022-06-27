defmodule BlitzWeb.RoomLive.Show do
  use BlitzWeb, :live_view
  import Phoenix.LiveView.Helpers
  alias Blitz.Rooms
  alias Blitz.Rooms.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    room = Rooms.get_room!(Enum.at(Helpers.Hashid.decode(id), 0))

    if connected?(socket), do: Rooms.subscribe(room)

    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:room, room)
      |> assign(:user, %User{})
      |> assign(:user_changeset, Rooms.change_user(%User{}))
      |> assign(:users, Rooms.list_users(room))
      |> assign(:round, Rooms.latest_round(room))
    }
  end

  @impl true
  def handle_event("validate_user", %{"user" => params}, socket) do
    changeset =
      %User{}
      |> Rooms.change_user(params)
      |> Map.put(:action, :insert)
    {:noreply,
     socket
     |> assign(user_changeset: changeset )}
  end
  def handle_event("create_user", %{"user" => params}, socket) do
    user_created(Rooms.create_user(Map.merge(params, %{"room_id" => socket.assigns.room.id})), socket)
  end

  defp user_created({:ok, user}, socket) do
    {:noreply,
      socket
      |> assign(user: user )
      |> assign(user_changeset: nil )}
  end
  defp user_created({:error, changeset}, socket) do
    {:noreply,
      socket
      |> assign(user_changeset: changeset )}
  end

  defp page_title(:show), do: "Show Room"
  defp page_title(:edit), do: "Edit Room"

  @impl true
  def handle_info({:user_created, user}, socket) do
    {:noreply,
    update(socket, :users, fn users -> [user | users] end)}
  end
  def handle_info({:room_updated, room}, socket) do
    {:noreply,
    assign(socket, :room, room)}
  end
  def handle_info({:round_created, round}, socket) do
    {:noreply,
     socket
     |> assign(:round, round)
     |> assign(:scores, Rooms.list_scores(round))}
  end
  def handle_info({:score_created, score}, socket) do
    {:noreply,
    update(socket, :scores, fn scores -> [score | scores] end)}
  end
end
