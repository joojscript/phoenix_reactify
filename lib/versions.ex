defmodule PhoenixReactify.Versions do
  @versions [phoenix: "1.5.9+", node: "5+", npm: "4+", elixir: "1.12+", erlang: "24.0+"]

  def get!(key) when is_atom(key) do
    @versions[key]
  end
end
