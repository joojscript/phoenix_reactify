defmodule PhoenixReactify.Helpers.Erlang do
  use PhoenixReactify.Helper

  def available? do
    {:ok, System.otp_release(), @descriptor}
  end
end
