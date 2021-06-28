defmodule PhoenixReactify.Helper do
  defmacro __using__(_opts) do
    quote do
      @descriptor String.split(to_string(__MODULE__), ".") |> Enum.reverse() |> Enum.at(0)
    end
  end
end
