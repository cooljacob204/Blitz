defmodule BlitzWeb.PageController do
  use BlitzWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
