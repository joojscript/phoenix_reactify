# Advanced Usage

As you probably already read at the [main README file](https://github.com/joojscript/phoenix_reactify/blob/master/README.md), this project uses [Remount](https://github.com/rstacruz/remount), to build your entries for your spa, or spas, if you want to.

What this library does, is that it compiles all .tsx/.jsx and react-stuff, into an html tag that can be embedded into your phoenix project easily, and it will understand and render correctly.

With this capabilities, we can, for instance, build lots of spas, one tag describing one route, or one tag for each "mini-spa-application" inside your domain.

Phoenix Reactify start off by building only one, and embedding it. For casual users, or simple projects, this should satisfy their needs, because all then, becomes just react code (supporting any kind of libs and etc...).

So, here's a simple guide if you want to step ahead and create one more spa inside the project:

## Getting things Working

It is **very** important that you have already ran `mix phx.reactify`, and your project have been correctly generated, as in [this project's README file](https://github.com/joojscript/phoenix_reactify/blob/master/README.md).

## Let's Build our new SPA

As the default name for Phoenix Reactify's generated spa, is spa. This new one, will be called **"intra"** (for intranet, or something like that).

So our steps will be:
1. Creating our React Structure as we like (I'll go simple here, but feel free).
2. Mounting it to our desired tag with **remount**
3. Adding the new generated remount tag to any of our **.html.eex** files.

### Creating our react structure

As I mentioned, I'll go simple in this one, and just create a simple Hello World element (you can think of it as [CRA](https://create-react-app.dev)'s App.tsx element) under **assets/js/intra/src/Hello.tsx**.

```javascript
import React from 'react';

const Hello: React.FC = () => {
  return <h1>Hello Reactify!</h1>;
}

export default Hello;
```

Now that we have our element, let's use remount to create our entrypoint. By default, Phoenix Reactify already creates a entrypoint.[js|ts] file inside src folder, you can use it, if you want to, or create other, or even use remount inside your component file directly. I'll go with the second approach, and create another entrypoint just for this new project, so **assets/js/intra/src/entrypoint.ts** will be like that:

```javascript
import {define} from 'remount';

import Hello from './Hello';

define({ 'x-intra-hello': Hello });
```

We're almost done, but right now, out phoenix **app.js** don't know our application yet.

By the last line of **assets/js/app.js**, import your entrypoint:

```javascript
import "phoenix_html"
import './intra/src/entrypoint'
```

Now we're all done! Hope it helps!
