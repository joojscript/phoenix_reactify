defmodule PhoenixReactify.Helpers.Erlang do
  @spec available? :: {:ok, String.t()}
  def available? do
    System.otp_release()
  end
end
