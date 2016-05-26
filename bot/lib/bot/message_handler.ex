defmodule Bot.MessageHandler do
  require Logger

  def handle(msg = %{message: %{text: _text}}) do
    # do something with the text
  end

  def handle(msg) do
    Logger.info "I don't know how to handle this message: \n#{inspect msg}"
  end
end