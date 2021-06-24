defmodule PhoenixReactify.Helpers.Babel do
  @doc """
    Add the specified entry to the .babelrc under the current path
  """
  @spec add_entry_to_babelrc(String.t(), String.t()) :: :ok
  def add_entry_to_babelrc(current_path, entry) do
    decoded = Jason.decode!(File.read!("#{current_path}/assets/.babelrc"))

    updatedBabelRc = Map.put(decoded, "presets", Map.get(decoded, "presets", []) ++ ["#{entry}"])

    File.write!(
      "#{current_path}/assets/.babelrc",
      """
        #{Jason.encode!(updatedBabelRc)}
      """
    )
  end
end
