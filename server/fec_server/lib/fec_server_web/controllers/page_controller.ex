defmodule FecServerWeb.PageController do
  use FecServerWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
