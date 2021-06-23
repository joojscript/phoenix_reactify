defmodule PhoenixReactify.Helpers.CreateReactApp do
  @spec available? :: {:ok, String.t()}
  def available? do
    {version, _} = System.cmd("npm", ["view", "create-react-app", "version"])
    version
  end

  def run(project_name \\ "spa", opts \\ [typescript: false]) do
    build_opts = ["create-react-app", "#{project_name}"]

    conditions = [
      {opts[:typescript], "--template=typescript"},
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

    {output, _} = System.cmd("npx", build_opts)
    output
  end
end
