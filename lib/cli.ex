defmodule Mix.Tasks.PhoenixReactify do
  use Mix.Task
  alias PhoenixReactify.Helpers

  def run(args) do
    options = [
      switches: [typescript: :boolean, verbose: :boolean],
      aliases: [t: :typescript, v: :verbose]
    ]

    {opts, _, _} = OptionParser.parse(args, options)

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

    IO.inspect(opts, label: "Command Line Arguments")
  end
end
