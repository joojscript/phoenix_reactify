defmodule PhoenixReactify.Helpers.Erlang do
  def available? do
    System.otp_release()
  end
end
