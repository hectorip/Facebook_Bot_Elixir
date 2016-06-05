defmodule Bot.MessageHandler do
  require Logger
  @fb_page_access_token System.get_env("FB_PAGE_ACCESS_TOKEN")

  def handle(msg = %{message: %{text: _text}}) do
    # do something with the text
    buttons = [
      %{type: "web_url", title: "hectoripm.com", url: "http://hectoripm.com"},
      %{type: "postback", title: "Héctor Iván Patricio Moreno", payload: "PB_NAME"}
    ]
    IO.inspect msg
    send_button_message msg.sender.id, "Escoge una de las siguientes opciones", buttons
  end

  def handle(msg) do
    Logger.info "I don't know how to handle this message: \n#{inspect msg}"
  end

  def send_button_message(recipient, message, buttons) do
    payload = %{
      recipient: %{id: recipient},
      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "button",
            text: message,
            buttons: buttons
          }
        }
      }
    }

    url = "https://graph.facebook.com/v2.6/me/messages?access_token=#{@fb_page_access_token}"
    headers = [{"Content-type", "application/json"}]
    IO.inspect(HTTPoison.post! url, Poison.encode!(payload), headers)
  end
end