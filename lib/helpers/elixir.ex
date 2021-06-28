defmodule PhoenixReactify.Helpers.Elixir do
  use PhoenixReactify.Helper

  def available? do
    compatible?(System.version())
  end
end
