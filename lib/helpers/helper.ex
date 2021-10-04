defmodule PhoenixReactify.Helper do
  defmacro __using__(_opts) do
    quote do
      defp clear_left_input(value) do
        cond do
          is_nil(value) ->
            0

          !Regex.match?(~r/^\d+$/, value) ->
            0

          !is_nil(value) ->
            String.to_integer(value)

          true ->
            0
        end
      end

      defp clear_right_input(value) do
        cond do
          is_nil(value) -> 0
          !Regex.match?(~r/^\d+$/, value) -> 0
          String.last(value) == "+" -> String.to_integer(Enum.at(String.split(value, "+"), 0))
          true -> String.to_integer(value)
        end
      end

      @descriptor String.split(to_string(__MODULE__), ".") |> Enum.reverse() |> Enum.at(0)

      def compatible?(version \\ "") do
        split_param_arr = version |> String.split(".")

        phoenix_supported_versions =
          PhoenixReactify.Versions.get!(@descriptor |> String.downcase() |> String.to_atom())

        split_supported_arr = phoenix_supported_versions |> String.split(".")

        try do
          for index <- 0..max(length(split_param_arr), length(split_supported_arr)) do
            left = clear_left_input(Enum.at(split_param_arr, index))

            right = clear_right_input(Enum.at(split_supported_arr, index))

            result = left >= right

            if !result do
              throw(:uncompatible)
            end
          end

          {:ok, version, @descriptor}
        catch
          :uncompatible -> {:error, :uncompatible, @descriptor}
        end
      end
    end
  end
end
