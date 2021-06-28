defmodule PhoenixReactify.Helpers.Erlang do
  use PhoenixReactify.Helper

  def available? do
    compatible?(System.otp_release())
  end
end
