defmodule PhoenixReactify.Helpers.Phoenix do
  use PhoenixReactify.Helper

  def available? do
    try do
      {"Phoenix v" <> version, _} =
        System.cmd("mix", ["phx.new", "--version", "--quiet"], stderr_to_stdout: true)

      {:ok, version, @descriptor}
    rescue
      _ -> {:error, :not_installed, @descriptor}
    end
  end

  def add_spa_tag_to_index_page_template!(opts) do
    line = "#{opts[:base_path]}/mix.exs" |> File.stream!() |> Enum.take(1)
    [app_name | _] = Regex.run(~r/(\S+)(?=\.)/, to_string(line))

    File.write!(
      "#{opts[:base_path]}/lib/#{String.downcase(app_name)}_web/templates/page/index.html.eex",
      """
      <x-#{opts[:project_name]} />
      """
    )

    opts
  end
end
