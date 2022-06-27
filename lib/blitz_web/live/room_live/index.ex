defmodule BlitzWeb.RoomLive.Index do
  use BlitzWeb, :live_view

  alias Blitz.Rooms

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :rooms, list_rooms())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("create", %{}, socket) do
    {:ok, room} = Rooms.create_room(%{})

    socket
    |> assign(:page_title, room.id)

    {:noreply, push_redirect(socket, to: Routes.room_show_path(socket, :show, Helpers.Hashid.encode(room.id)))}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Room")
    |> assign(:room, Rooms.get_room!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Room")
    |> assign(:room, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rooms")
    |> assign(:room, nil)
  end

  defp list_rooms do
    Rooms.list_rooms()
  end
end
