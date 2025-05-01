/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/code/config.md
````
```js
/** @type {import('tailwindcss').Config} */

module.exports = {
  presets: [
    require('tailwindcss-preset-email')
  ],
  theme: {
    extend: {
      colors: {
        blue: {
          brand: '#286dbd',
        },
      },
    }
  },
}
```

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/code/environment.md
````
```js
/** @type {import('@maizzle/framework').Config} */

export default {
  build: {
    content: ['emails/**/*.html'],
    output: {
      path: 'build_production',
    },
  },
  css: {
    inline: true,
    purge: true,
    shorthand: true,
  },
  prettify: true,
}
```

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/code/template.md
````
```html
<x-main>
  <table class="mx-auto font-inter">
    <tr>
      <td class="w-[600px] max-w-full bg-white">
        <h1 class="text-2xl/8 text-slate-950">
          BYOHTML
        </h1>

        <p class="text-base/6 text-slate-600">
          Bring your own HTML
        </p>

        <x-button href="https://maizzle.com">
          Read more
        </x-button>
      </td>
    </tr>
  </table>
</x-main>
```

````
