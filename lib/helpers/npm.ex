defmodule(PhoenixReactify.Helpers.Npm) do
  use PhoenixReactify.Helper

  alias PhoenixReactify.Helpers

  def available? do
    try do
      {version, _} = System.cmd("npm", ["--version"])
      compatible?(String.trim(version))
    rescue
      _ -> {:error, :not_installed, @descriptor}
    end
  end

  def run_npm_install!(opts \\ [verbose: false, npm_force_install: false]) do
    install_opts = ["i"]

    conditions = [
      {!opts[:verbose], "--silent"},
      {opts[:npm_force_install], "--force"}
    ]

    install_opts =
      install_opts ++
        Enum.reduce(conditions, [], fn
          {true, item}, list ->
            [item | list]

          _, list ->
            list
        end)

    File.cd!("#{opts[:base_path]}/assets")

    {output, _} = System.cmd("npm", install_opts)

    File.cd!("#{opts[:base_path]}")

    if opts[:verbose] do
      IO.puts("#{output}")
    end

    output
  end

  def install_remount!(opts \\ [verbose: false, npm_force_install: false]) do
    install_opts = ["i", "remount"]

    conditions = [
      {!opts[:verbose], "--silent"},
      {opts[:npm_force_install], "--force"}
    ]

    install_opts =
      install_opts ++
        Enum.reduce(conditions, [], fn
          {true, item}, list ->
            [item | list]

          _, list ->
            list
        end)

    File.cd!("#{opts[:base_path]}/assets")

    {output, _} = System.cmd("npm", install_opts)

    File.cd!("#{opts[:base_path]}")

    if opts[:verbose] do
      IO.puts("#{output}")
    end

    output
  end

  def install_react!(opts \\ [typescript: false, verbose: false, npm_force_install: false]) do
    build_opts = [
      "i",
      "react",
      "react-dom",
      "@babel/preset-react",
      "@babel/core",
      "@babel/preset-env"
    ]

    Helpers.Babel.add_entry_to_babelrc(opts[:base_path], "@babel/preset-react")

    conditions = [
      {!opts[:verbose], "--silent"},
      {opts[:npm_force_install], "--force"}
    ]

    build_opts =
      build_opts ++
        Enum.reduce(conditions, [], fn
          {true, item}, list ->
            [item | list]

          _, list ->
            list
        end)

    File.cd!("#{opts[:base_path]}/assets")

    {output, _} = System.cmd("npm", build_opts)

    File.cd!("#{opts[:base_path]}")

    if opts[:verbose] do
      IO.puts("#{output}")
    end

    output
  end

  def install_typescript!(opts \\ [typescript: true, verbose: false, npm_force_install: false]) do
    build_opts = [
      "i",
      "--save-dev",
      "@babel/preset-typescript",
      "typescript",
      "@types/react"
    ]

    conditions = [
      {!opts[:verbose], "--silent"},
      {opts[:npm_force_install], "--force"}
    ]

    Helpers.Babel.add_entry_to_babelrc(opts[:base_path], "@babel/preset-typescript")

    File.touch!("#{File.cwd!()}/assets/tsconfig.json")

    File.write!(
      "#{opts[:base_path]}/assets/tsconfig.json",
      """
        {
          "compilerOptions": {
            "outDir": "../priv/static/js",
            "noImplicitAny": true,
            "module": "es6",
            "target": "es5",
            "jsx": "react",
            "allowJs": true,
            "moduleResolution": "node",
            "allowSyntheticDefaultImports": true
          }
        }
      """
    )

    File.write!(
      "#{opts[:base_path]}/assets/webpack.config.js",
      PhoenixReactify.Helpers.Webpack.get_config_file_as_string()
    )

    build_opts =
      build_opts ++
        Enum.reduce(conditions, [], fn
          {true, item}, list ->
            [item | list]

          _, list ->
            list
        end)

    File.cd!("#{opts[:base_path]}/assets")

    {output, _} = System.cmd("npm", build_opts)

    File.cd!("#{opts[:base_path]}")

    if opts[:verbose] do
      IO.puts("#{output}")
    end

    install_ts_loader!(opts)

    output
  end

  defp install_ts_loader!(opts \\ [verbose: false, npm_force_install: false]) do
    File.cd!("#{opts[:base_path]}/assets")

    build_opts = [
      "i",
      "--save-dev",
      "ts-loader@8.2.0"
    ]

    conditions = [
      {!opts[:verbose], "--silent"},
      {opts[:npm_force_install], "--force"}
    ]

    build_opts =
      build_opts ++
        Enum.reduce(conditions, [], fn
          {true, item}, list ->
            [item | list]

          _, list ->
            list
        end)

    {output, _} = System.cmd("npm", build_opts)

    if opts[:verbose] do
      IO.puts("#{output}")
    end

    File.cd!("#{opts[:base_path]}")

    output
  end

  def add_sample_files!(
        opts \\ [typescript: false, verbose: false, base_path: "", project_name: "spa"]
      ) do
    project_path = "#{opts[:base_path]}/assets/js/#{opts[:project_name]}"

    File.mkdir!("#{project_path}")
    File.mkdir!("#{project_path}/src")

    if opts[:typescript] do
      create_react_ts_files!(opts, project_path)
    else
      create_react_js_files!(opts, project_path)
    end
  end

  defp create_react_js_files!(opts, project_path) do
    if opts[:verbose] do
      IO.write("\nCreating App.js under src directory...")
    end

    File.touch!("#{project_path}/src/App.js")

    File.write!("#{project_path}/src/App.js", """
      import React from 'react';

      const App = () => {
        return <div className="phx-hero">
          <img src="https://github.com/joojscript/phoenix_reactify/blob/master/.github/phoenix_reactify.png?raw=true" alt="Phoenix Reactify Logo" />
          <h1>Welcome to Phoenix Reactify!</h1>
          <p>The message is being rendered by your new generated SPA!</p>
        </div>;
      }

      export default App;
    """)

    if opts[:verbose] do
      IO.write("\r✅ Created App.js under src directory.")
    end
  end

  defp create_react_ts_files!(opts, project_path) do
    if opts[:verbose] do
      IO.write("\nCreating App.tsx under src directory...")
    end

    File.touch!("#{project_path}/src/App.tsx")

    File.write!("#{project_path}/src/App.tsx", """
        import React from 'react';

        const App: React.FC = () => {
          return <div className="phx-hero">
            <img src="https://github.com/joojscript/phoenix_reactify/blob/master/.github/phoenix_reactify.png?raw=true" alt="Phoenix Reactify Logo" />
            <h1>Welcome to Phoenix Reactify!</h1>
            <p>The message is being rendered by your new generated SPA!</p>
          </div>;
        }

        export default App;
    """)

    if opts[:verbose] do
      IO.puts("\r✅ Created App.tsx under src directory.")
    end
  end
end
