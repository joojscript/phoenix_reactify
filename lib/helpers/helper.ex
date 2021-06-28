defmodule PhoenixReactify.Helper do
  defmacro __using__(_opts) do
    quote do
      @descriptor String.split(to_string(__MODULE__), ".") |> Enum.reverse() |> Enum.at(0)

      def compatible?(version \\ "") do
        split_param_arr = version |> String.split(".")

        phoenix_supported_versions =
          PhoenixReactify.Versions.get!(@descriptor |> String.downcase() |> String.to_atom())

        split_supported_arr = phoenix_supported_versions |> String.split(".")

        try do
          for index <- 0..max(length(split_param_arr), length(split_supported_arr)) do
            left =
              if !is_nil(Enum.at(split_param_arr, index)),
                do: String.to_integer(Enum.at(split_param_arr, index)),
                else: 0

            right =
              if !is_nil(Enum.at(split_supported_arr, index)),
                do:
                  if(String.last(Enum.at(split_supported_arr, index)) == "+",
                    do:
                      String.to_integer(
                        Enum.at(String.split(Enum.at(split_supported_arr, index), "+"), 0)
                      ),
                    else: String.to_integer(Enum.at(split_supported_arr, index))
                  ),
                else: 0

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
