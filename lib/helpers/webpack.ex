defmodule PhoenixReactify.Helpers.Webpack do
  def get_config_file_as_string do
    """
      const path = require("path");
      const glob = require("glob");
      const HardSourceWebpackPlugin = require("hard-source-webpack-plugin");
      const MiniCssExtractPlugin = require("mini-css-extract-plugin");
      const TerserPlugin = require("terser-webpack-plugin");
      const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");
      const CopyWebpackPlugin = require("copy-webpack-plugin");

      module.exports = (env, options) => {
        const devMode = options.mode !== "production";

        return {
          optimization: {
            minimizer: [
              new TerserPlugin({ cache: true, parallel: true, sourceMap: devMode }),
              new OptimizeCSSAssetsPlugin({}),
            ],
          },
          entry: {
            app: glob.sync("./vendor/**/*.js").concat(["./js/app.js"]),
          },
          output: {
            filename: "[name].js",
            path: path.resolve(__dirname, "../priv/static/js"),
            publicPath: "/js/",
          },
          devtool: devMode ? "eval-cheap-module-source-map" : undefined,
          resolve: {
            extensions: [".tsx", ".ts", ".js", ".json"],
          },
          module: {
            rules: [
              {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                  loader: "babel-loader",
                },
              },
              {
                test: /\.[s]?css$/,
                use: [MiniCssExtractPlugin.loader, "css-loader", "sass-loader"],
              },
              {
                test: /\.tsx?$/,
                use: "ts-loader",
                exclude: /node_modules/,
              },
            ],
          },
          plugins: [
            new MiniCssExtractPlugin({ filename: "../css/app.css" }),
            new CopyWebpackPlugin([{ from: "static/", to: "../" }]),
          ].concat(devMode ? [new HardSourceWebpackPlugin()] : []),
        };
      };
    """
  end

  # Would be great, but Jason has not yet added Regex Parsing support, so...

  # {output, _} =
  #   System.cmd("node", [
  #     "-e",
  #     "console.log(JSON.stringify(require('./assets/webpack.config.js')('dev', {mode: 'dev'})))"
  #   ])

  # output_as_map = Jason.decode!(output)

  # Map.put_new(
  #   output_as_map,
  #   "resolve",
  #   Jason.encode!(%{
  #     "extensions" => [".tsx", ".ts", ".js"]
  #   })
  # )

  # Map.put(
  #   output_as_map,
  #   "module.rules",
  #   Map.get(output_as_map, "module.rules") ++
  #     [
  #       Jason.encode!(%{
  #         "test" => "/\.tsx?$/",
  #         "use" => "ts-loader",
  #         "exclude" => "/node_modules/"
  #       })
  #     ]
  # )
end
