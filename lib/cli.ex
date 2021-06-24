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

    {parsed_opts, _, _} = OptionParser.parse(args, options)

    assigns =
      if !parsed_opts[:project_name],
        do: [project_name: "spa", base_path: File.cwd!()],
        else: [base_path: File.cwd!()]

    opts = parsed_opts ++ assigns

    opts
    |> verify_prerequisites
    |> verify_if_is_phoenix_project
    |> generate_react_project
    |> add_remount

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

  #  Tries to verify if the current directory is a phoenix project.
  #    - Not 100% effective
  #    - Just as a preventive step.
  #    - Assets mainly by the directory structure.
  defp verify_if_is_phoenix_project(opts) do
    CliSpinners.spin_fun(
      [text: "Verifying Phoenix Project", done: "✅ Phoenix Project Verified"],
      fn ->
        tasks = [
          Task.async(fn -> File.exists?("#{opts[:base_path]}/lib") end),
          Task.async(fn -> File.exists?("#{opts[:base_path]}/deps") end),
          Task.async(fn -> File.exists?("#{opts[:base_path]}/config") end),
          Task.async(fn -> File.exists?("#{opts[:base_path]}/assets") end),
          Task.async(fn -> File.exists?("#{opts[:base_path]}/priv") end),
          Task.async(fn -> File.exists?("#{opts[:base_path]}/test") end)
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
    Helpers.Npm.install_react!(opts)

    if opts[:typescript] do
      Helpers.Npm.install_typescript!(opts)
    end

    Helpers.Npm.add_sample_files!(opts)

    opts
  end

  defp add_remount(opts) do
    Helpers.Npm.install_remount!(opts)

    if opts[:typescript] do
      File.touch!("#{opts[:base_path]}/assets/js/#{opts[:project_name]}/src/entrypoint.ts")

      File.write!("#{opts[:base_path]}/assets/js/#{opts[:project_name]}/src/entrypoint.ts", """
        import {define} from 'remount';

        import App from './App';

        define({ 'x-#{opts[:project_name]}': App });
      """)
    else
      File.touch!("#{opts[:base_path]}/assets/js/#{opts[:project_name]}/src/entrypoint.js")

      File.write!("#{opts[:base_path]}/assets/js/#{opts[:project_name]}/src/entrypoint.js", """
        import {define} from 'remount';

        import App from './App';

        define({ 'x-#{opts[:project_name]}': App });
      """)
    end

    File.write!(
      "#{opts[:base_path]}/assets/js/app.js",
      """
        import './#{opts[:project_name]}/src/entrypoint'
      """,
      [:append]
    )

    opts
  end
end
