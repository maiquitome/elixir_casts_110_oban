defmodule TeacherWeb.PageController do
  use TeacherWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
    # without oban:
    # Teacher.Processor.process()

    # with oban:
    %{id: 1}
    |> Teacher.Business.new()
    |> Oban.insert()
    # |> IO.inspect(label: "Finish Oban.insert()")

    conn
    |> put_flash(:info, "Work completed")
    |> render("done.html")
  end
end
