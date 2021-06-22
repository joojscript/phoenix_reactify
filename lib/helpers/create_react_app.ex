defmodule PhoenixReactify.Helpers.CreateReactApp do
  @spec available? :: {:ok, String.t()}
  def available? do
    {version, _} = System.cmd("npm", ["view", "create-react-app", "version"])
    version
  end
end
