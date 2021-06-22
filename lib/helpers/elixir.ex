defmodule PhoenixReactify.Helpers.Elixir do
  @spec available? :: {:ok, String.t()}
  def available? do
    System.version()
  end
end
