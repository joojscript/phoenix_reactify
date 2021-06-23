defmodule PhoenixReactify.Helpers.Npm do
  @spec available? :: {:ok, String.t()}
  def available? do
    {version, _} = System.cmd("npm", ["--version"])
    version
  end

  def install_remount(opts \\ []) do
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

    output
  end

  def install_babel_presets(opts \\ []) do
    install_opts = ["i", "@babel/preset-react"]

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

    output
  end

  def install_react(project_name \\ "spa", opts \\ [typescript: false, verbose: false]) do
    build_opts = ["i", "react", "react-dom"]

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
    output
  end

  def add_sample_files(project_name \\ "spa", opts \\ [typescript: false, verbose: false]) do
    current_path = File.cwd!()
    project_path = "#{current_path}/#{project_name}"

    if opts[:verbose] do
      IO.puts("Creating App.js under src directory...")
    end

    File.mkdir!("#{project_path}/src")
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
end
