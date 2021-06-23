defmodule Mix.Tasks.Phx.Reactify do
  @moduledoc """
    Generates directory and dependencies structure to use React inside your
    Phoenix project
  """
  @shortdoc """
    Reactify your Phoenix Project
  """

  use Mix.Task
  alias PhoenixReactify.Helpers

  def run(args) do
    options = [
      switches: [typescript: :boolean, verbose: :boolean, project_name: :string],
      aliases: [t: :typescript, v: :verbose, p: :project_name]
    ]

    {opts, _, _} = OptionParser.parse(args, options)

    opts
    |> verify_prerequisites
    |> verify_if_is_phoenix_project
    |> generate_react_project

    IO.inspect(opts, label: "Command Line Arguments")
  end

  defp verify_prerequisites(opts) do
    CliSpinners.spin_fun(
      [text: "Verifying Prerequisites", done: "✅ Prerequisites Verified"],
      fn ->
        tasks = [
          Task.async(fn -> Helpers.Npm.available?() end),
          Task.async(fn -> Helpers.CreateReactApp.available?() end),
          Task.async(fn -> Helpers.Elixir.available?() end),
          Task.async(fn -> Helpers.Erlang.available?() end)
        ]

        [
          {_, {:ok, npm_version}},
          {_, {:ok, create_react_app_version}},
          {_, {:ok, elixir_version}},
          {_, {:ok, erlang_version}}
        ] = Task.yield_many(tasks, :infinity)

        if opts[:verbose] do
          IO.puts("""


            NPM: #{npm_version}
            CREATE-REACT-APP: #{create_react_app_version}
            ELIXIR: #{elixir_version}

            ERLANG: #{erlang_version}
          """)
        end
      end
    )

    opts
  end

  @doc """
    Tries to verify if the current directory is a phoenix project.
      - Not 100% effective
      - Just as a preventive step.
      - Assets mainly by the directory structure.
  """
  defp verify_if_is_phoenix_project(opts) do
    {:ok, current_path} = File.cwd()

    CliSpinners.spin_fun(
      [text: "Verifying Phoenix Project", done: "✅ Phoenix Project Verified"],
      fn ->
        tasks = [
          Task.async(fn -> File.exists?("#{current_path}/lib") end),
          Task.async(fn -> File.exists?("#{current_path}/deps") end),
          Task.async(fn -> File.exists?("#{current_path}/config") end),
          Task.async(fn -> File.exists?("#{current_path}/assets") end),
          Task.async(fn -> File.exists?("#{current_path}/priv") end),
          Task.async(fn -> File.exists?("#{current_path}/test") end)
        ]

        results = Task.yield_many(tasks, :infinity)

        Enum.each(results, fn task ->
          {_task, {:ok, exists}} = task

          if !exists do
            raise(RuntimeError, "Is not a Phoenix Project")
          end
        end)
      end
    )

    opts
  end

  defp generate_react_project(opts) do
    {:ok, current_path} = File.cwd()
    File.cd("#{current_path}/assets/js")
    {:ok, current_path} = File.cwd()
    project_name = if opts[:project_name], do: opts[:project_name], else: "spa"

    File.mkdir("#{current_path}/#{project_name}")
    File.cd("#{current_path}/assets/js/#{project_name}")
    output = PhoenixReactify.Helpers.CreateReactApp.run(project_name, opts)

    if opts[:verbose] do
      IO.puts("#{output}")
    end

    opts
  end
end
