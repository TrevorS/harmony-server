defmodule Harmony.Router do
  use Plug.Router

  plug Plug.Logger

  plug :match
  plug :dispatch

  match _ do
    send_resp(conn, 200, "Hello from Harmony")
  end
end
