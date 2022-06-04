defmodule BlitzWeb.RoomLive.Show do
  use BlitzWeb, :live_view

  alias Blitz.Lobbies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:room, Lobbies.get_room!(Enum.at(Helpers.Hashid.decode(id), 0)))}
  end

  defp page_title(:show), do: "Show Room"
  defp page_title(:edit), do: "Edit Room"
end
