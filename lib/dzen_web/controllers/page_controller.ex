defmodule DzenWeb.PageController do
  use DzenWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
