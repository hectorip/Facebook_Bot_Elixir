defmodule Bot.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/webhook" do
    conn = Plug.Conn.fetch_query_params(conn)
    IO.inspect conn.params
    if conn.params["hub.verify_token"] == "secret-token" do
      send_resp(conn, 200, conn.params["hub.challenge"])
    else
      send_resp(conn, 401, "Error, wrong validation token")
    end
  end

  post "/webhook" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    body
    |> Poison.Parser.parse!(keys: :atoms)
    |> Map.get(:entry)
    |> hd  # Getting the head of the list, raise error in case of empty list.
    |> Map.get(:messaging)
    |> Enum.each(&Bot.MessageHandler.handle/1)

    send_respo(conn, 200, "Processing message")
  end

  match _ do
    send_resp(conn, 404, "404 - Page not found")
  end
end