defmodule BlitzWeb.RoomLive.Show do
  use BlitzWeb, :live_view
  import Phoenix.LiveView.Helpers
  alias Blitz.Lobbies
  alias Blitz.Lobbies.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    room = Lobbies.get_room!(Enum.at(Helpers.Hashid.decode(id), 0))

    if connected?(socket), do: Lobbies.subscribe(room)

    {
      :noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:room, room)
      |> assign(:user, %User{})
      |> assign(:user_changeset, Lobbies.change_user(%User{}))
      |> assign(:users, Lobbies.list_users(room))
    }
  end

  @impl true
  def handle_event("validate_user", %{"user" => params}, socket) do
    changeset =
      %User{}
      |> Lobbies.change_user(params)
      |> Map.put(:action, :insert)
    {:noreply,
     socket
     |> assign(user_changeset: changeset )}
  end

  def handle_event("create_user", %{"user" => params}, socket) do
    user_created(Lobbies.create_user(Map.merge(params, %{"room_id" => socket.assigns.room.id})), socket)
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
end
