defmodule PhoenixReactify.Helpers.Elixir do
  use PhoenixReactify.Helper

  def available? do
    {:ok, System.version(), @descriptor}
  end
end
