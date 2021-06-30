defmodule Mix.Tasks.Phx.Reactify do
  @shortdoc """
    Reactify your Phoenix Project
  """
  use Mix.Task

  def run(args \\ []) do
    PhoenixReactify.main(args)
  end
end
