defmodule PhoenixReactify.Helpers.Phoenix do
  def available? do
    {"Phoenix v" <> version, _} = System.cmd("mix", ["phx.new", "--version"])
    version
  end

  def add_spa_tag_to_index_page_template!(opts) do
    line = "#{opts[:base_path]}/mix.exs" |> File.stream!() |> Enum.take(1)
    [app_name | _] = Regex.run(~r/(\S+)(?=\.)/, to_string(line))

    File.write!(
      "#{opts[:base_path]}/lib/#{String.downcase(app_name)}_web/templates/page/index.html.eex",
      """
      <section class="phx-hero">
        <h1><%= gettext "Welcome to %{name}!", name: "Phoenix" %></h1>
        <p>Peace of mind from prototype to production</p>
      </section>

      <x-#{opts[:project_name]} />
      """
    )

    opts
  end
end
