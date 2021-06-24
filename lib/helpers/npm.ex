defmodule(PhoenixReactify.Helpers.Npm) do
  alias PhoenixReactify.Helpers

  @spec available? :: {:ok, String.t()}
  def available? do
    {version, _} = System.cmd("npm", ["--version"])
    version
  end

  def install_remount!(opts \\ []) do
    install_opts = ["i", "remount"]

    conditions = [
      {!opts[:verbose], "--silent"}
    ]

    install_opts =
      install_opts ++
        Enum.reduce(conditions, [], fn
          {true, item}, list ->
            [item | list]

          _, list ->
            list
        end)

    {output, _} = System.cmd("npm", install_opts)

    if opts[:verbose] do
      IO.puts("#{output}")
    end

    output
  end

  def install_react!(opts \\ [typescript: false, verbose: false]) do
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
      {!opts[:verbose], "--silent"}
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

    output
  end

  def install_typescript!(opts \\ [typescript: true, verbose: false]) do
    build_opts = [
      "i",
      "--save-dev",
      "@babel/preset-typescript",
      "typescript",
      "ts-loader@8.2.0",
      "@types/react"
    ]

    conditions = [
      {!opts[:verbose], "--silent"}
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

    {output, _} = System.cmd("npm", build_opts)

    if opts[:verbose] do
      IO.puts("#{output}")
    end

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
      IO.puts("Creating App.js under src directory...")
    end

    File.touch!("#{project_path}/src/App.js")

    File.write!("#{project_path}/src/App.js", """
      import React from 'react';

      function App() {
        return <h1>Hello World!</h1>;
      }

      export default App;
    """)

    if opts[:verbose] do
      IO.puts("Creted App.js under src directory.")
    end
  end

  defp create_react_ts_files!(opts, project_path) do
    if opts[:verbose] do
      IO.puts("Creating App.tsx under src directory...")
    end

    File.touch!("#{project_path}/src/App.tsx")

    File.write!("#{project_path}/src/App.tsx", """
      import React from 'react';

      const App: React.FC = () => {
        return <h1>hello world from ts</h1>;
      }

      export default App;
    """)

    if opts[:verbose] do
      IO.puts("Creted App.tsx under src directory.")
    end
  end
end
