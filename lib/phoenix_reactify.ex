defmodule PhoenixReactify do
  @moduledoc """
    Generates directory and dependencies structure to use React inside your
    Phoenix project
  """
  alias PhoenixReactify.Helpers

  def main(args) do
    options = [
      switches: [
        typescript: :boolean,
        verbose: :boolean,
        project_name: :string,
        npm_force_install: :boolean
      ],
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

  defp verify_prerequisites(opts) do
    IO.write("Verifying Prerequisites...")

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
            IO.puts("\n✔ #{String.upcase(descriptor)} installed [#{version}]")
          end

        {:error, :uncompatible, descriptor} ->
          IO.puts("\n#{String.upcase(descriptor)} is not compatible")

          IO.puts(
            "\nCompatible versions include #{String.upcase(descriptor)} -> #{PhoenixReactify.Versions.get!(String.to_atom(String.downcase(descriptor)))}"
          )

          IO.puts("\n❌ Pre-Requisites not satisfied")
          System.halt(0)

        {:error, :not_installed, descriptor} ->
          IO.puts("\n#{String.upcase(descriptor)} is not installed")
          IO.puts("\n❌ Pre-Requisites not satisfied")
          System.halt(0)
      end
    end)

    IO.write("\r✅ Prerequisites Verified\n")

    opts
  end

  #  Tries to verify if the current directory is a phoenix project.
  #    - Not 100% effective
  #    - Just as a preventive step.
  #    - Assets mainly by the directory structure.
  defp verify_if_is_phoenix_project(opts) do
    IO.write("Verifying Phoenix Project...")

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

    IO.write("\r✅ Phoenix Project Verified\n")

    opts
  end

  defp generate_react_project(opts) do
    IO.write("Intalling React...")
    Helpers.Npm.install_react!(opts)
    IO.write("\r✅ React installed\n")

    if opts[:typescript] do
      IO.write("Intalling TypeScript...")
      Helpers.Npm.install_typescript!(opts)
      IO.write("\r✅ Typescript installed\n")
    end

    IO.write("Adding sample files...")
    Helpers.Npm.add_sample_files!(opts)
    IO.write("\r✅ Sample Files added\n")

    opts
  end

  defp add_remount(opts) do
    IO.write("Installing Remount...")
    Helpers.Npm.install_remount!(opts)
    IO.write("\r✅ Remount installed\n")

    IO.write("Adding entrypoints...")

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

    IO.write("\r✅ Entrypoints Added\n")

    opts
  end

  defp add_tag_to_index_template(opts) do
    IO.write("Adding first tag to templates/pages/index.html.eex...")
    Helpers.Phoenix.add_spa_tag_to_index_page_template!(opts)
    IO.write("\r✅ Tag Added\n")

    opts
  end

  defp run_last_check(opts) do
    IO.write("Running last check...")
    Helpers.Npm.run_npm_install!(opts)
    IO.write("\r🚀 All set\n")

    opts
  end
end
