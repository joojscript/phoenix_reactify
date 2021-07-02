# Advanced Usage

As you probably already read at the [main README file](https://github.com/joojscript/phoenix_reactify/README.md), this project uses [Remount](https://github.com/rstacruz/remount), to build your entries for your spa, or spas, if you want to.

What this library does, is that it compiles all .tsx/.jsx and react-stuff, into an html tag that can be embedded into your phoenix project easily, and it will understand and render correctly.

With this capabilities, we can, for instance, build lots of spas, one tag describing one route, or one tag for each "mini-spa-application" inside your domain.

Phoenix Reactify start off by building only one, and embedding it. For casual users, or simple projects, this should satisfy their needs, because all then, becomes just react code (supporting any kind of libs and etc...).

So, here's a simple guide if you want to step ahead and create one more spa inside the project:

## Getting things Working

It is **very** important that you have already ran `mix phx.reactify`, and your project have been correctly generated, as in [this project's README file](https://github.com/joojscript/phoenix_reactify/README.md).
