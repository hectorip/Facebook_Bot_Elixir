defmodule Bot.Server do
  @default_port 4000

  def start_link(nil), do: start_server(@default_port)
  def start_link(port), do: port |> String.to_integer |> start_server

  def start_server(port) do
    Plug.Adapters.Cowboy.http(Bot.Router, [], port: port)
  end
end