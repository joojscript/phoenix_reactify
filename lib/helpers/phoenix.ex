defmodule PhoenixReactify.Helpers.Phoenix do
  use PhoenixReactify.Helper

  def available? do
    try do
      {raw, _} = System.cmd("mix", ["phx.new", "--version"], stderr_to_stdout: true)

      [version] =
        Regex.run(
          ~r/\d.?\d.?\d/,
          raw
        )

      compatible?(String.trim(version))
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
