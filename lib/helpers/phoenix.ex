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
    try do
      [web_dir] = Path.wildcard("#{opts[:base_path]}/lib/*_web")
      template_dir = "#{web_dir}/templates/page/"
      [template] = Path.wildcard("#{template_dir}/index.html.*eex")
      File.write!(
        template,
        """
        <x-#{opts[:project_name]} />
        """
      )
      opts
    rescue
      _ -> {:error, :not_installed, @descriptor}
    end
  end
end
