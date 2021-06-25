<h1 align="center">
  <img src="https://github.com/joojscript/phoenix_reactify/blob/master/.github/phoenix_reactify.png?raw=true" /> <br />
  Phoenix Reactify
</h1>

<h1 align="center">
  <img src="https://img.shields.io/hexpm/v/phoenix_reactify?style=for-the-badge" />
  <img src="https://img.shields.io/hexpm/l/phoenix_reactify?style=for-the-badge" />
  <img src="https://img.shields.io/hexpm/dt/phoenix_reactify?style=for-the-badge" />
  <img src="https://img.shields.io/github/issues/joojscript/phoenix_reactify?style=for-the-badge" />
  <img src="https://img.shields.io/github/stars/joojscript/phoenix_reactify?style=for-the-badge" />
</h1>

**Phoenix Reactify** is an amazing **mix task** capable of adding a  simple React implementation to your fresh **phoenix projects**.

⚠ **WARNING**: Currently, because of some webpack version related issues, this library its only compatible with **Phoenix 1.5.9** or any other that have webpack ~4.5 as peer-dependency.

### How does PhoenixReactify works?

It uses the amazing [remount](https://github.com/rstacruz/remount) library to make your entire SPA App into a html tag, so that you can use into your phoenix application's templates

## Installation

The package is available in Hex, so just paste this into your **mix.exs** file:

```elixir
def deps do
  [
    # other dependencies
    {:phoenix_reactify, "~> 0.0.2"}
  ]
end
```

## Usage

At this moment, Phoenix Reactify supports these options:

- -p, --project: Specifies the React project name (Default to SPA).
- -v, --verbose: Ensures verbose output.
- -t, --typescript: Enables Typescript support.

```sh
mix phx.reactify --typescript --project <PROJECT-NAME> --verbose
```

After all set, you can embbed your spa, as <x-**YOUR-PROJECT-NAME** \> onto any of your .html.eex files.

⚠ **WARNING**: be careful with route conflicts between the applications


## ToDo
  
  - 🕐 Automatic route mapping (probably via macros or something like that).
  - ✅ Typescript support (deppends on babel).
  - ✅ Auto-Inject first generated tag (not trully necessary, but I think it would be more user-friendly).
  
## License
[MIT](https://choosealicense.com/licenses/mit/)
