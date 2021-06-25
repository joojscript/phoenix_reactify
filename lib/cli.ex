defmodule PhoenixReactify.CLI do
  def main(args \\ []) do
    Mix.Tasks.Phx.Reactify.run(args)
  end
end
