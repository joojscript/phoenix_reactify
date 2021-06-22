defmodule PhoenixReactify.Helpers.Npm do
  @spec available? :: {:ok, String.t()}
  def available? do
    {version, _} = System.cmd("npm", ["--version"])
    version
  end
end
