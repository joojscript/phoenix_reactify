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

My first idea was to release it as a mix archive, so that you could use it in any project, once installed, just like ```mix phx.new``` command. But since mix archives cannot bundle dependencies (and this project has), I had to release it in two different ways:
  - As a hex.pm package, that you can install like this, pasting this code into your **mix.exs** file:

```elixir
def deps do
  [
    # other dependencies
    {:phoenix_reactify, "~> 0.0.2"}
  ]
end
```

Feel free to remove it from the dependencies once you've set up your project 😄

 - Or, at every release I put a binary-compiled file altogether, you can download it [directly from the releases page](https://github.com/joojscript/phoenix_reactify/releases), and then, run it inside your fresh phoenix project.

```bash
$ ./phoenix_reactify
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
