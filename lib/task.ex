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
    |> add_tag_to_index_template
    |> run_last_check

    if opts[:verbose] do
      IO.inspect(opts, label: "Command Line Arguments")
    end
  end

  def verify_prerequisites(opts) do
    CliSpinners.spin_fun(
      [text: "Verifying Prerequisites\n", done: "✅ Prerequisites Verified\n"],
      fn ->
        tasks = [
          Task.async(fn -> Helpers.Npm.available?() end),
          Task.async(fn -> Helpers.Elixir.available?() end),
          Task.async(fn -> Helpers.Erlang.available?() end),
          Task.async(fn -> Helpers.Phoenix.available?() end)
        ]

        Task.yield_many(tasks, :infinity)
        |> Enum.map(fn {_, {:ok, task}} ->
          case task do
            {:ok, version, descriptor} ->
              if opts[:verbose] do
                IO.puts("✔ #{String.upcase(descriptor)} installed [#{version}]")
              end

            {:error, :not_installed, descriptor} ->
              IO.puts("\n#{String.upcase(descriptor)} is not installed")
              IO.puts("❌ Pre-Requisites not satisfied")
              System.halt(0)
          end
        end)
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
    CliSpinners.spin_fun(
      [text: "Installing React", done: "✅ React installed"],
      fn ->
        Helpers.Npm.install_react!(opts)
      end
    )

    if opts[:typescript] do
      CliSpinners.spin_fun(
        [text: "Intalling TypeScript", done: "✅ Typescript installed"],
        fn ->
          Helpers.Npm.install_typescript!(opts)
        end
      )
    end

    CliSpinners.spin_fun(
      [text: "Adding sample files", done: "✅ Sample Files added"],
      fn ->
        Helpers.Npm.add_sample_files!(opts)
      end
    )

    opts
  end

  defp add_remount(opts) do
    CliSpinners.spin_fun(
      [text: "Intalling Remount", done: "✅ Remount installed"],
      fn ->
        Helpers.Npm.install_remount!(opts)
      end
    )

    CliSpinners.spin_fun(
      [text: "Adding Entrypoints", done: "✅ Entrypoints Added"],
      fn ->
        if opts[:typescript] do
          File.touch!("#{opts[:base_path]}/assets/js/#{opts[:project_name]}/src/entrypoint.ts")

          File.write!(
            "#{opts[:base_path]}/assets/js/#{opts[:project_name]}/src/entrypoint.ts",
            """
              import {define} from 'remount';

              import App from './App';

              define({ 'x-#{opts[:project_name]}': App });
            """
          )
        else
          File.touch!("#{opts[:base_path]}/assets/js/#{opts[:project_name]}/src/entrypoint.js")

          File.write!(
            "#{opts[:base_path]}/assets/js/#{opts[:project_name]}/src/entrypoint.js",
            """
              import {define} from 'remount';

              import App from './App';

              define({ 'x-#{opts[:project_name]}': App });
            """
          )
        end

        File.write!(
          "#{opts[:base_path]}/assets/js/app.js",
          """
            import './#{opts[:project_name]}/src/entrypoint'
          """,
          [:append]
        )
      end
    )

    opts
  end

  defp add_tag_to_index_template(opts) do
    CliSpinners.spin_fun(
      [text: "Adding first tag to templates/pages/index.html.eex", done: "✅ Tag Added"],
      fn ->
        Helpers.Phoenix.add_spa_tag_to_index_page_template!(opts)
      end
    )
  end

  defp run_last_check(opts) do
    CliSpinners.spin_fun(
      [text: "Running last check", done: "🚀 All set"],
      fn ->
        Helpers.Npm.run_npm_install!(opts)
      end
    )
  end
end
