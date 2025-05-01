/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/guides/amp-email.md
````
---
title: "How to create an AMP for Email template"
description: "Use AMP for Email in Maizzle to easily create interactive HTML emails with realtime information and in-line actions."
date: 2021-03-03
---

# How to create an AMP for Email template

<p class="text-sm">Last updated: March 18, 2023</p>

In this tutorial, you'll learn how to make use of custom config files in Maizzle to create interactive AMP for Email templates.

For a syntax refresher, checkout the [AMP Email docs](https://amp.dev/documentation/guides-and-tutorials/start/create_email/?format=email) or [AMP Email examples](https://amp.dev/documentation/examples/?format=email).

Want to dive right in? Checkout our [AMP for Email Starter](https://github.com/maizzle/starter-amp4email).

## Initial setup

As always, let's scaffold a new project:

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./amp-emails`, and select the Default Starter.

Choose Yes when prompted to Install dependencies.

Once it finishes installing dependencies, open the project folder in your favorite editor.

## Layout

AMP for Email requires some special markup, so let's create an `amp.html` Layout and save it under `layouts`:

```html [layouts/amp.html]
<!doctype html>
<html ⚡4email>
<head>
  <meta charset="utf-8">
  <script async src="https://cdn.ampproject.org/v0.js"></script>
  <style amp4email-boilerplate>body{visibility:hidden}</style>
  <style amp-custom>{{{ page.css }}}</style>
  <stack name="head" />
</head>
<body>
  <yield />
</body>
</html>
```

## Template

For this tutorial, we'll use the [AMP Carousel](https://amp.dev/documentation/components/amp-carousel/?format=email) component.

Create `emails/amp/carousel.html` and add a basic AMP carousel:

```html [emails/amp/carousel.html]
<x-amp>
  <push name="head">
    <script async custom-element="amp-carousel" src="https://cdn.ampproject.org/v0/amp-carousel-0.2.js"></script>
  </push>

  <div class="p-4">
    <div class="max-w-full">
      <amp-carousel width="600" height="400" layout="responsive" type="slides">
        <amp-img src="https://ampbyexample.com/img/image1.jpg" width="600" height="400" alt="a sample image" />
        <amp-img src="https://ampbyexample.com/img/image2.jpg" width="600" height="400" alt="another sample image" />
        <amp-img src="https://ampbyexample.com/img/image3.jpg" width="600" height="400" alt="and another sample image" />
      </amp-carousel>
    </div>
  </div>
</x-amp>
```

You initialize [AMP components](https://amp.dev/documentation/guides-and-tutorials/learn/email-spec/amp-email-components/?format=email) by pushing their `<script>` tag to the `<stack name="head" />` from the layout, as shown above.

You can then use the component's markup inside `<fill:template></fill:template>`.

## CSS inlining

Inline style attributes are not allowed in AMP, so you need to disable CSS inlining.

Do it either globally, in your environment config:

```js [config.js]
export default {
  css: {
    inline: false,
  }
}
```

... or locally, in the Template's Front Matter:

```yaml [emails/amp/carousel.html]
---
css:
  inline: false
---
```

## !important

AMP for Email doesn't support `!important` in CSS, either.

This can be easily turned off in your Tailwind config:

```js [tailwind.config.js]
export default {
  important: false,
}
```

However, you probably want to turn it off _only_ for AMP templates.

You can do this by updating your `<style>` tag for AMP templates to use a different Tailwind config file:

```html [layouts/amp.html]
<style>
  @config 'tailwind.amp.js';
  @tailwind components;
  @tailwind utilities;
</style>
```

Next, duplicate `tailwind.config.js` to `tailwind.amp.js` and disable `important`:

```js [tailwind.amp.js]
module.exports = {
  important: false,
}
```

Finally, run `maizzle build amp` to build your ⚡4email templates.

In case you haven't installed the [Maizzle CLI](/docs/cli), add an NPM script to `package.json`:

```json [package.json]
"scripts": {
  "build:amp": "maizzle build amp"
}
```

You'd then build your AMP emails by running `npm run build:amp`.


## Resources

- [Official AMP for Email docs](https://amp.dev/documentation/guides-and-tutorials/start/create_email/?format=email)
- [Maizzle AMP for Email Starter](https://github.com/maizzle/starter-amp4email)

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/guides/custom-fonts.md
````
---
title: "Using custom web fonts in Maizzle email templates"
description: "Learn how to include custom web fonts in your email templates and use them efficiently through Tailwind CSS utilities."
date: 2020-01-31
---

# Using custom web fonts in Maizzle email templates

<p class="text-sm">Last updated: May 30, 2022</p>

It's super easy to [use Google Fonts in your Maizzle email templates](/docs/examples/google-fonts), but what if you need to use a custom web font?

Maybe your brand uses a custom font that isn't available through Google Fonts, or maybe you're just developing Shopify notification email templates (where the usual `@import` and `<link>` techniques aren't supported).

In this tutorial, you'll learn how to add your own custom fonts to emails in Maizzle.

## Initial setup

First, let's scaffold a new project:

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./example-font-face`, and select the Default Starter.

Choose Yes when prompted to Install dependencies.

Once it finishes installing dependencies, open the project folder in your favorite editor.

## Register @font-face

Imagine we have a display font called Barosan, which we're hosting on our website.

We'll use `@font-face` to register our custom font family - we can do this in the Template or in the Layout that we extend.

### Add in Template

Open `emails/transactional.html` and add this before the `<x-main>` tag:

```html [emails/transactional.html]
<push name="head">
  <style>
    @font-face {
      font-family: 'Barosan';
      font-style: normal;
      font-weight: 400;
      src: local('Barosan Regular'), local('Barosan-Regular'), url(https://example.com/fonts/barosan.woff2) format('woff2');
    }
  </style>
</push>
```

This adds a separate `<style>` tag in the compiled email HTML, right after the main one.

### Add in Layout

If you prefer a single `<style>` tag in your email template, you can register the font in the Layout instead. Open `layouts/main.html` and update the `<style>` tag:

```css [layouts/main.html] no-copy {2-7}
   <style>
     @font-face { /* [!code ++] */
       font-family: 'Barosan'; /* [!code ++] */
       font-style: normal; /* [!code ++] */
       font-weight: 400; /* [!code ++] */
       src: local('Barosan Regular'), local('Barosan-Regular'), url(https://example.com/fonts/barosan.woff2) format('woff2'); /* [!code ++] */
     } /* [!code ++] */

     @tailwind components;
     @tailwind utilities;
   </style>
```

<Alert>
You can use the same technique to load font files from Google Fonts - it's currently the only way to get them working in Shopify notifications. To find out the URL of a Google Font (and actually, its entire `@font-face` CSS) simply access the URL they give you, in a new browser tab.
</Alert>

## Tailwind CSS utility

Now that we're importing the font, we should register a Tailwind CSS utility for it.

Open `tailwind.config.js`, scroll down to `fontFamily`, and add a new font:

```js [tailwind.config.js] {5}
export default {
  theme: {
    extend: {
      fontFamily: {
        barosan: ['Barosan', '-apple-system', '"Segoe UI"', 'sans-serif'], /* [!code ++] */
      }
    },
  },
}
```

Of course, you can change the other fonts in the stack. For example, display fonts often fallback to `cursive`.

Great! We're now ready to use the utility class in our email template.

## Quick use

Add the `font-barosan` class on elements that you want to use your custom font.

For example, you can add it on a heading:

```html
<h2 class="font-barosan">An article title</h2>
```

With [CSS inlining](/docs/transformers/inline-css) enabled, that would result in:

```html
<h2 style="font-family: Barosan, -apple-system, 'Segoe UI', sans-serif;">An article title</h2>
```

## Advanced use

Repeatedly writing that `font-barosan` class on all elements isn't just impractical, it also increases HTML file size (especially when inlining), which then leads to [Gmail clipping](https://github.com/hteumeuleu/email-bugs/issues/41).

`font-family` is inherited, which means you can just add the utility to the top element:

```html [emails/transactional.html]
<x-main>
  <table class="font-barosan">
    <!-- your email HTML... -->
  </table>
</x-main>
```

However, that could trigger [Outlook's Times New Roman bug](https://www.caniemail.com/search/?s=font#font-face-cite-note-5).

We can work around that by making use of Tailwind's `screen` variants and an Outlook `font-family` fallback to reduce bloat and write less code 👌

First, let's register a new `@media` query - we will call it `screen`:

```js [tailwind.config.js] {6}
export default {
  theme: {
    screens: {
      sm: {max: '600px'},
      xs: {max: '425px'},
      screen: {raw: 'screen'}, // [!code ++]
    }
  }
}
```

We can now use it on the outermost<sup>1</sup> element:

```html [emails/transactional.html]
<x-main>
  <table class="screen:font-barosan">
    <!-- your email HTML... -->
  </table>
</x-main>
```

<Alert><sup>1</sup> Don't add it to the `<body>` - some email clients remove or replace this tag.</Alert>

This will tuck the `font-family` away in an `@media` query:

```css
/* Compiled CSS. Maizzle replaces escaped \: with - */
@media screen {
  .screen-font-barosan {
    font-family: Barosan, -apple-system, "Segoe UI", sans-serif !important;
  }
}
```

Since Outlook on Windows doesn't read `@media` queries, define a fallback<sup>2</sup> for it in the `<head>` of your Layout:

```html [layouts/main.html]
<!--[if mso]>
<style>
  td,th,div,p,a,h1,h2,h3,h4,h5,h6 {font-family: "Segoe UI", sans-serif;}
</style>
<![endif]-->
```

<Alert><sup>2</sup> The Maizzle Starter includes this fallback in the `main.html` Layout by default.</Alert>

## Outlook bugs

Custom fonts aren't supported in Outlook 2007-2019 on Windows - most of these email clients will fallback to Times New Roman if you try to use one.

To avoid this, you can wrap the `@font-face` declaration in a `@media` query, so that Outlook will ignore it:

```css
@media screen {
  @font-face {
    font-family: 'Barosan';
    font-style: normal;
    font-weight: 400;
    src: local('Barosan Regular'), local('Barosan-Regular'), url(https://example.com/fonts/barosan.woff2) format('woff2');
  }
}
```

Also, note that `font-family` isn't inherited on child elements in Outlook.

## Extra weights

If your font comes with dedicated files for other weights, don't just slap `font-bold` on an element.

Instead, import both the regular and bold versions of your font:

```css
@font-face {
  font-family: 'Barosan';
  font-style: normal;
  font-weight: 400;
  src: local('Barosan Regular'), local('Barosan-Regular'), url(https://example.com/fonts/barosan.woff2) format('woff2');
}

@font-face {
  font-family: 'Barosan';
  font-style: normal;
  font-weight: 700;
  src: local('Barosan Bold'), local('Barosan-Bold'), url(https://example.com/fonts/barosan-bold.woff2) format('woff2');
}
```

## Resources

- [The Ultimate Guide to Web Fonts](https://litmus.com/blog/the-ultimate-guide-to-web-fonts) on Litmus
- [@font-face support in email](https://www.caniemail.com/features/css-at-font-face/)

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/guides/gradients.md
````
---
title: "How to use CSS background gradients in HTML emails"
description: "Learn how to add CSS background image gradients with Outlook VML fallback to your HTML email templates in Maizzle."
date: 2020-02-21
---

# How to use CSS background gradients in HTML emails

<p class="text-sm">Last updated: May 30, 2022</p>

Many email clients [support CSS background gradients](https://www.caniemail.com/features/css-linear-gradient/).

In this tutorial, you will learn how to use the [tailwindcss-gradients](https://www.npmjs.com/package/tailwindcss-gradients) plugin to add colorful gradients to your HTML email templates. We will also cover how to add a <abbr title="Vector Markup Language">VML</abbr> fallback for Outlook on Windows.

## Getting started

Let's start by creating a new Maizzle project.

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./example-gradients`, and select the Default Starter.

Choose Yes when prompted to Install dependencies.

After dependencies finish installing, change the current directory to `example-gradients`:

```sh
cd example-gradients
```

Next, install the `tailwindcss-gradients` plugin:

```sh
npm install tailwindcss-gradients
```

Once it finishes, open the `example-gradients` folder in your favorite code editor.

## CSS Gradients

Let's configure and use `tailwindcss-gradients` with Tailwind CSS.

### Tailwind CSS config

We need to tell Tailwind CSS to use the plugin. Edit `tailwind.config.js` and `require()` the plugin inside the `plugins: []` array:

```js [tailwind.config.js] {3}
module.exports = {
  plugins: [
    require('tailwindcss-gradients'), // [!code ++]
  ]
}
```

Next, we need to define what kind of gradients we want to generate, based on which colors. We do that in the `theme: {}` key from `tailwind.config.js`.

For example, let's register linear gradients based on the existing color palette:

```js [tailwind.config.js] {3}
module.exports = {
  theme: {
    linearGradientColors: theme => theme('colors'), // [!code ++]
  }
}
```

<Alert>`tailwindcss-gradients` can generate many other types of gradients (although not all are supported in email). See all <a href="https://github.com/benface/tailwindcss-gradients">configuration options</a>.</Alert>

### Use in HTML

Simply add the utility class on an element that supports `background-image` CSS.

We also specify a background color first, so that email clients that don't support CSS background-image gradients can display a fallback:

```html [emails/example.html]
<x-main>
  <table class="w-full">
    <tr>
      <td class="bg-gray-200 bg-gradient-b-black">
        <!-- ... -->
      </td>
    </tr>
  </table>
</x-main>
```

## Outlook VML

Outlook for Windows doesn't support CSS gradients, but we can use <abbr title="Vector Markup Language">VML</abbr>.

You need to add it right after the element with the CSS gradient class:

```html [emails/example.html] {5-11}
<x-main>
  <table class="w-full">
    <tr>
      <td class="bg-blue-500 bg-gradient-b-black-transparent">
        <!--[if gte mso 9]>
        <v:rect xmlns:v="urn:schemas-microsoft-com:vml" fill="true" stroke="false" style="width:600px;">
        <v:fill type="gradient" color="#0072FF" color2="#00C6FF" angle="90" />
        <v:textbox style="mso-fit-shape-to-text:true" inset="0,0,0,0">
        <div><![endif]-->
        [your overlayed HTML here]
        <!--[if gte mso 9]></div></v:textbox></v:rect><![endif]-->
      </td>
    </tr>
  </table>
</x-main>
```

As you can see, you need to set a fixed width on the `<v:rect>` element - it is recommended instead of using `mso-width-percent: 1000;`, as that is pretty buggy (especially in Outlook 2013).

<Alert>The width of the `<v:rect>` element needs to match the width of its parent element.</Alert>

### Body gradient

We can also add a VML gradient to the body of the email.

To achieve this, we:

1. create a `<div>` that wraps our template: this will be used as the solid background color fallback
2. place the VML code immediately inside that div, basically wrapping our entire template. Note how we're using `mso-width-percent: 1000;` instead of a fixed width on the `<v:rect>`

Here's an example:

```html [emails/example.html]
<x-main>
  <div class="bg-gray-200">
    <!--[if gte mso 9]>
    <v:rect xmlns:v="urn:schemas-microsoft-com:vml" fill="true" stroke="false" style="mso-width-percent:1000;">
    <v:fill type="gradient" color="#edf2f7" color2="#cbd5e0" />
    <v:textbox style="mso-fit-shape-to-text:true" inset="0,0,0,0">
    <div><![endif]-->
    <table class="w-full font-sans">
      <tr>
        <td align="center" class="bg-gradient-t-gray-400">
          <!-- your content here... -->
        </td>
      </tr>
    </table>
    <!--[if gte mso 9]></div></v:textbox></v:rect><![endif]-->
  </div>
</x-main>
```

You can see both examples in the [project repository](https://github.com/maizzle/example-gradients).

## Avoid inlining

Most email clients that support CSS gradients also support `@media` queries.

We can register a `screen` breakpoint to prevent Juice from inlining our gradient:

```js [tailwind.config.js] {6}
module.exports = {
  theme: {
    screens: {
      sm: {max: '600px'},
      xs: {max: '425px'},
      screen: {raw: 'screen'}, // [!code ++]
    }
  }
}
```

We can then write the utility class like this:

```html [emails/example.html]
<x-main>
  <table class="w-full">
    <tr>
      <td class="bg-gray-200 screen:bg-gradient-b-black">
        <!-- ... -->
      </td>
    </tr>
  </table>
</x-main>
```

## Resources

- [tailwindcss-gradients](https://www.npmjs.com/package/tailwindcss-gradients) plugin
- [GitHub repository](https://github.com/maizzle/starter-gradients) for this tutorial

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/guides/mailchimp-package.md
````
---
title: "Automating Mailchimp template zip packaging with Maizzle"
description: "Using events in Maizzle to automatically package email templates and their images into a zip archive that can be uploaded to Mailchimp."
date: 2023-08-04
---

# Automating Mailchimp template zip packaging with Maizzle

If you've ever built custom email templates to be used in Mailchimp, you know that one way to upload them to a campaign is to create a .zip archive that includes the HTML file and all its images.

And if you've done this for many templates, you also know that it can be a tedious process.

In this guide, you'll learn how to use Maizzle's [events](/docs/events) to automatically package your templates and their images into a zip archive that can be uploaded to Mailchimp.

If you want to dive right in, check out the [Mailchimp Starter](https://github.com/maizzle/starter-mailchimp).

## Requirements

Mailchimp requires that the zip archive contains the HTML file and all its images in the same folder.

For example:

```html
template.zip
├── index.html
├── image1.jpg
├── image2.jpg
└── image3.jpg
```

With this in mind, we must also make sure that the images are referenced correctly in the HTML file. In order for an image to be uploaded to Mailchimp's servers, it must be referenced using a relative path:

```html {2}
  <img src="https://some-cdn.com/image1.jpg"> <!-- [!code --] -->
  <img src="image1.jpg"> <!-- [!code ++] -->
```

## Project setup

We're starting from scratch, so let's scaffold a new project using the Official Starter:

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./mailchimp-project`, and select the Default Starter.

Choose Yes when prompted to Install dependencies.

Once it finishes installing dependencies, open the project folder in your favorite editor.

### Structure

We'll be organizing our templates into folders inside `templates`:

```html
src
└── templates
    └── template-1
        ├── index.html
        ├── image1.jpg
        ├── image2.jpg
        └── image3.jpg
    └── ...
```

This will not only make it easier to create the .zip archive, but this way we can also easily add and reference images in the HTML.

## Create a template

For this written guide, we'll be using a simplified template with a few images. See the [Mailchimp Starter](https://github.com/maizzle/starter-mailchimp) for a more extensive example.

Create `emails/template-1/index.html` and paste in the following code:

```html [emails/template-1/index.html]
---
title: "Example template 1"
---

<x-main>
  <!-- Condition needed in order to see global images when developing locally -->
  <if condition="page.env === 'local'">
    <img src="/images/insignia.png" width="70" alt="Maizzle">
  </if>
  <else>
    <img src="insignia.png" width="70" alt="Maizzle">
  </else>

  <h1>
    Hello,
  </h1>

  <p>
    As you might know, lorem ipsum dolor sit amet...
  </p>

  <div>
    <img src="maizzle.png" width="456" alt="Maizzle cover image">
  </div>

  <p>
    Lorem, ipsum dolor sit amet consectetur adipisicing elit. Possimus ex deserunt, placeat.
  </p>

  <div>
    <img src="tailwindcss.jpg" width="456" alt="Tailwind CSS cover image">
  </div>

  <p>
    Lorem, ipsum dolor sit amet consectetur adipisicing elit. Possimus ex deserunt, placeat, suscipit sapiente non minus necessitatibus vero hic.
  </p>
</x-main>
```

Make sure to save the [`maizzle.png`](https://maizzle.com/__og_image__/og.png) and [`tailwindcss.jpg`](https://tailwindcss.com/_next/static/media/social-card-large.a6e71726.jpg) images to the same folder.

## Production config

This is where the magic happens.

Our strategy is as follows:

- for each template, create a list of the images it uses
- push that list along with some data about the template file to a queue
- after all templates have been compiled, process the queue and create the .zip archives

For now, update your `config.production.js` to look like this:

```js [config.production.js] {1,5}
const queue = []

export default {
  build: {
    static: false,
    output: {
      path: 'dist',
    },
  },
  css: {
    inline: true,
    purge: true,
    shorthand: true,
  },
  prettify: true,
```

We're setting `static: false` because we don't want Maizzle to copy the global `images` folder to the `dist` folder. We'll handle any global images ourselves.

## Get image paths from HTML

We'll need a way of creating a list of images that are used in a template.

Create `utils/getImagePaths.js` and paste in the following code:

```js [utils/getImagePaths.js]
export default function htmlString() {
  const imagePaths = []
  const regexSrcAttribute = /src=["'](.*?)["']/gi
  const regexBackgroundAttribute = /background=["'](.*?)["']/gi
  const regexInlineBackgroundCSS = /background(-image)?:\s?url\(['"](.*?)['"]\)/gi
  const regexSrcsetAttribute = /srcset=["'](.*?)["']/gi
  const regexPosterAttribute = /poster=["'](.*?)["']/gi
  const regexStyleTag = /<style\b[^>]*>(.*?)<\/style>/gi

  // Extract image paths from src attributes
  const srcMatches = htmlString.match(regexSrcAttribute)
  if (srcMatches) {
    srcMatches.forEach(match => {
      const imagePath = match.replace(regexSrcAttribute, '$1')
      imagePaths.push(imagePath)
    })
  }

  // Extract image paths from background attributes
  const backgroundMatches = htmlString.match(regexBackgroundAttribute)
  if (backgroundMatches) {
    backgroundMatches.forEach(match => {
      const imagePath = match.replace(regexBackgroundAttribute, '$1')
      imagePaths.push(imagePath)
    })
  }

  // Extract image paths from inline background CSS
  const inlineBackgroundMatches = htmlString.match(regexInlineBackgroundCSS)
  if (inlineBackgroundMatches) {
    inlineBackgroundMatches.forEach(match => {
      const imagePath = match.replace(regexInlineBackgroundCSS, '$2')
      imagePaths.push(imagePath)
    })
  }

  // Extract image paths from srcset attributes
  const srcsetMatches = htmlString.match(regexSrcsetAttribute)
  if (srcsetMatches) {
    srcsetMatches.forEach(match => {
      const imagePath = match.replace(regexSrcsetAttribute, '$1')
      // Split the srcset and add each image path individually
      const imagePathsArray = imagePath.split(/\s*,\s*/)
      imagePaths.push(...imagePathsArray)
    })
  }

  // Extract image paths from poster attributes
  const posterMatches = htmlString.match(regexPosterAttribute)
  if (posterMatches) {
    posterMatches.forEach(match => {
      const imagePath = match.replace(regexPosterAttribute, '$1')
      imagePaths.push(imagePath)
    })
  }

  // Extract image paths from CSS inside <style> tags in the <head>
  const styleTagMatches = htmlString.match(regexStyleTag)
  if (styleTagMatches) {
    styleTagMatches.forEach(styleTag => {
      const cssMatches = styleTag.match(regexInlineBackgroundCSS)
      if (cssMatches) {
        cssMatches.forEach(match => {
          const imagePath = match.replace(regexInlineBackgroundCSS, '$2')
          imagePaths.push(imagePath)
        })
      }
    })
  }

  return imagePaths
}
```

This will return an array of image paths extracted from the following:

- `src` attributes
- `srcset` attributes
- `poster` attributes
- `background` attributes
- CSS inside `<style>` tags in the `<head>`
- inline `background` and `background-image` CSS

## Archiving library

There are a few libraries that can create .zip archives, but we'll be using [archiver](https://www.npmjs.com/package/archiver) for this guide.

Install it now:

```bash
npm install archiver
```

## Add to the queue

Let's use the `afterTransformers` event to push information about each template and the images it uses to the `queue` variable that we defined earlier.

Modify your `config.production.js` to look like this:

```js [config.production.js] {18-29}
import getImagePathsFromHTML from './utils/getImagePaths.js'

const queue = []

export default {
  build: {
    static: false,
    output: {
      path: 'dist',
    },
  },
  css: {
    inline: true,
    purge: true,
    shorthand: true,
  },
  prettify: true,
  afterTransformers(html, config) {
    // Get image paths from HTML
    const imagePaths = getImagePathsFromHTML(html)

    queue.push({
      images: imagePaths,
      ...config.build.current,
    })

    return html
  },
```

## Create the .zip archives

We can now process the queue and create the .zip archive for each template.

We'll use the `afterBuild` event for this, which is triggered after all templates have been compiled.

Modify your `config.production.js` to look like this:

```js [config.production.js] {1-4,33-77}
import fs from 'node:fs'
import path from 'node:path'
import archiver from 'archiver'
import baseConfig from './config.js'
import getImagePathsFromHTML from './utils/getImagePaths.js'

const queue = []

export default {
  build: {
    static: false,
    output: {
      path: 'dist',
    },
  },
  css: {
    inline: true,
    purge: true,
    shorthand: true,
  },
  prettify: true,
  afterTransformers(html, config) {
    // Get image paths from HTML
    const imagePaths = getImagePathsFromHTML(html)

    queue.push({
      images: imagePaths,
      ...config.build.current,
    })

    return html
  },
  afterBuild() {
    // Process each item in the queue
    for (const {path: template, images} of queue) {
      // Read template's directory
      fs.readdir(template.dir, (err, files) => {
        // Exit early if there's an error
        if (err) throw err

        // Create archive
        const output = fs.createWriteStream(`${template.dir}/${template.name}.zip`)
        const archive = archiver('zip', {
          zlib: {
            level: 9 // Sets the compression level
          }
        })

        archive.on('error', function(err) {
          throw err
        })

        // Pipe archive data to the file
        archive.pipe(output)

        // Add files from template's directory to archive
        files.forEach(file => {
          archive.file(`${template.dir}/${file}`, { name: file })
        })

        // Get a list of files found in `images` that have been used in the template
        const assetsSource = baseConfig.build.templates.assets.source
        const globalImages = fs.readdirSync(assetsSource)
          .filter(file => images.includes(path.basename(file)))
          .map(file => path.join(assetsSource, file))

        // Add global images to archive
        globalImages.forEach(image => {
          archive.file(image, { name: path.basename(image) })
        })

        // Finalize the archive
        archive.finalize()
      })
    }
  },
}
```

## Build the templates

Running the `npm run build` command will now create a .zip archive for each template in the `dist` directory.

The archive file will have the same name as the template, so you'll see something like this:

```html
build_production
  └── template-1
      ├── index.html
      └── index.zip
        ├── index.html
        ├── insignia.png
        ├── maizzle.png
        ├── tailwindcss.jpg
      ├── maizzle.png
      ├── tailwindcss.jpg
  └── template-2
      └── ...
```

You'll notice that `insignia.png` has been added to both archives, even though none of the template folders include it.

## Resources

- [GitHub repository](https://github.com/maizzle/starter-mailchimp) for this guide
- [archiver](https://www.npmjs.com/package/archiver) library documentation

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/guides/markdown-emails.md
````
---
title: "How to create an HTML email newsletter from Markdown files"
description: "Learn how to create responsive HTML emails from Markdown files in Maizzle. Write your newsletter in .md files, import components and style it all with Tailwind CSS."
date: 2022-12-05
---

# How to create an HTML email newsletter from Markdown files

In this tutorial, you'll learn how to create HTML emails from Markdown files in Maizzle.

You'll be able to compile Markdown files from a folder into responsive HTML emails, use components, expressions, and even style them with Tailwind CSS.

If you want to dive right in, check out the [Markdown Starter](https://github.com/maizzle/starter-markdown).

## Project setup

Scaffold a new project using the Markdown Starter:

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./markdown-project`, and select the Default Starter.

Choose Yes when prompted to Install dependencies.

Once it finishes installing dependencies, open the project folder in your favorite code editor.

### Structure

We'll be using the `content` folder to store our Markdown files:

```html
src
└── content
    └── newsletter-1.md
    └── newsletter-2.md
    └── ...
```

<Alert>You can remove the `emails` directory, we won't need it.</Alert>

Next, create `content/newsletter-1.md` and add some markdown to it:

```md [newsletter-1.md]
# Hello world

This is the first newsletter.
```

### Layout

Since we just want to write Markdown and not have to deal with any tables and such, we need to update `layouts/main.html` to contain the entire HTML boilerplate.

Replace its contents with the following:

```hbs [layouts/main.html]
<!doctype {{{ page.doctype || 'html' }}}>
<html lang="{{ page.language || 'en' }}" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
  <meta charset="{{ page.charset || 'utf-8' }}">
  <meta name="x-apple-disable-message-reformatting">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="format-detection" content="telephone=no, date=no, address=no, email=no, url=no">
  <!--[if mso]>
  <noscript>
    <xml>
      <o:OfficeDocumentSettings xmlns:o="urn:schemas-microsoft-com:office:office">
        <o:PixelsPerInch>96</o:PixelsPerInch>
      </o:OfficeDocumentSettings>
    </xml>
  </noscript>
  <style>
    td,th,div,p,a,h1,h2,h3,h4,h5,h6 {font-family: "Segoe UI", sans-serif; mso-line-height-rule: exactly;}
  </style>
  <![endif]-->
  <if condition="page.title">
    <title>{{{ page.title }}}</title>
  </if>
  <style>
    @tailwind utilities;
    @tailwind components;
  </style>
  <stack name="head" />
</head>
<body class="m-0 p-0 w-full [word-break:break-word] [-webkit-font-smoothing:antialiased] {{ page.bodyClass || 'bg-slate-100' }}">
  <if condition="page.preheader">
    <div class="hidden">
      {{{ page.preheader }}}
      <each loop="item in Array.from(Array(150))">&#847; </each>
    </div>
  </if>

  <div
    align="center"
    role="article"
    aria-roledescription="email"
    lang="{{ page.language || 'en' }}"
    class="{{ page.bodyClass || 'bg-slate-100' }}"
    aria-label="{{{ page.title || '' }}}"
  >
    <table class="font-sans">
      <tr>
        <td class="w-[600px] max-w-full bg-white rounded-xl">
          <table class="w-full">
            <tr>
              <td class="p-0 px-8 sm:px-4 text-base/6 text-slate-700">
                <yield />
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
```

### Dependencies

We'll need a couple of extra dependencies to parse the Markdown files:

- `front-matter` to be able to use [Front Matter](/docs/templates#front-matter) in our Markdown files
- `markdown-it-attrs` to be able to add Tailwind CSS classes right in Markdown

Let's install them:

```sh
npm install front-matter markdown-it-attrs
```

### config.js

Since we're not using the default setup anymore, we need to tell Maizzle where to look for 'templates' to compile.

Update `build.templates` to use .md files from the `content` folder:

```js [config.js] {3}
export default {
  build: {
    content: ['content/**/*.md'], // [!code ++]
  },
}
```

## Compile Markdown

If you run `npm run build` now, you'll notice the files output to `build_production` only include the raw, unparsed content of your Markdown files: they were not compiled to HTML, neither did they use our `main.html` layout.

Maizzle doesn't know what layout to use or that the content of our .md files is Markdown that needs parsing, so we need to instruct it to do that.

We can use the [`beforeRender` event](/docs/events#beforerender) for this:

```js [config.js]
import fm from 'front-matter'

export default {
  beforeRender(html) {
    const { body } = fm(html)

    return `
      <x-main>
        <md>${body}</md>
      </x-main>`
  },
}
```

Here's a step-by-step explanation of what's happening:

1. We're hooking into the `beforeRender` event to alter the HTML before it's compiled.
1. We use `front-matter` to extract the Markdown content from the file into a `body` variable. This ensures that we only parse Markdown content, and not the Front Matter too.
1. We're returning a string that includes the contents of the `body` property wrapped in `<md>` tags, so Maizzle can parse them as Markdown. See the [Markdown documentation](/docs/markdown) for more info on this tag. Finally, the `<x-main>` tag tells Maizzle to use our `main.html` layout.

Run `npm run build` again and you'll see that the files in the `build_production` folder are now compiled to HTML using our `main.html` layout 🥳

## Styling

Let's create a `css/markdown.css` file so we can add some global styles for our Markdown content:

```css [css/markdown.css]
h1 {
  @apply text-3xl leading-9;
}

p {
  @apply m-0 mb-8;
}

img {
  @apply max-w-full leading-full align-middle;
  border: 0;
}
```

Make sure to import this file in the `<style>` tag:

```html [layouts/main.html]
<style>
  @import "css/markdown.css";
  @import 'tailwindcss/components';
  @import 'tailwindcss/utilities';
</style>
```

Run `npm run build` again and you'll see that the styles are now applied:

```html [build_production/newsletter-1.html] {2} no-copy
  <h1>Hello world</h1> <!-- [!code --]-->
  <h1 style="font-size: 30px; line-height: 36px;">Hello world</h1> <!-- [!code ++]-->
```

### Tailwind CSS

We can also use Tailwind CSS classes directly in our Markdown files.

To do this, we'll use the `markdown-it-attrs` plugin, which allows us to add attributes like class names to elements right when writing Markdown.

Update `config.js` to have Maizzle use the plugin:

```js [config.js] {7}
import mdAttrs from 'markdown-it-attrs'

export default {
  markdown: {
    plugins: [
      {
        plugin: mdAttrs, // [!code ++]
      }
    ]
  },
}
```

You can now add Tailwind CSS classes to your Markdown elements by adding them inside curly braces after the content:

```md [content/newsletter-1.md]
---
title: "Edition #1"
---

# Hello world {.m-0 .mb-10 .text-slate-900}
```

Notice how classes include the leading dot, and are separated by spaces.

Result:

```html [build_production/newsletter-1.html] {2} no-copy
  <h1 style="font-size: 30px; line-height: 36px;">Hello world</h1> <!-- [!code --]-->
  <h1 style="font-size: 30px; line-height: 36px; margin: 0 0 40px; color: #0f172a">Hello world</h1> <!-- [!code ++]-->
```

### @tailwindcss/typography

Although it's the obvious choice for styling Markdown content with Tailwind, we don't recommend using [@tailwindcss/typography](https://tailwindcss.com/docs/typography-plugin) for Markdown _emails_.

The plugin is great for the web, but it contains complex CSS selectors that are not fully supported by most email clients, and cannot be properly inlined either.

Feel free to experiment with it, but consider yourself warned.

## Syntax highlighting

You can use syntax highlighters like [Shiki](https://shiki.matsu.io/) or [Prism](https://prismjs.com/) to add syntax highlighting to fenced code blocks in your markdown.

For example, here's how you'd use Shiki.

First, install the library:

```sh
npm install shiki
```

Next, define a custom `highlight` method for `markdown-it`. Add it in the `beforeCreate` event so that the highlighter is retrieved once, before templates are compiled:

```js [config.js]
import { createHighlighter } from 'shiki'

export default {
  async beforeCreate(config) {
    const highlighter = await createHighlighter({
      themes: ['nord'],
      langs: ['html'],
    })

    config = Object.assign(config, {
      markdown: {
        markdownit: {
          highlight: (code, lang) => {
            lang = lang || 'html'
            return highlighter.codeToHtml(code, { lang, theme: 'nord' })
          }
        }
      }
    })
  },
}
```

Now all your markdown code blocks will be highlighted with the Nord theme.

## Expressions

You can use [expressions](/docs/templates#expressions) in Markdown files just as you would in any Maizzle template:

```hbs [content/newsletter-1.md]
---
title: "Edition #1"
---

# {{ page.title }}

This is the first newsletter.
```

## Components

You can also import Maizzle components in your Markdown files.

For example, let's create an `<x-alert>` component:

```html [components/alert.html]
<table class="w-full mb-8">
  <tr>
    <td
      attributes
      class="py-2 px-4 bg-blue-100 text-blue-600 rounded"
    >
      <yield />
    </td>
  </tr>
</table>
```

Notice the `attributes` attribute - this indicates that any attributes passed to the component should be added to this element, instead of the root element.

We can use it like this:

```hbs [content/newsletter-1.md]
---
title: "Edition #1"
---

# {{ page.title }}

This is the first newsletter.

<x-alert>
  Notice: this is an alert.
</x-alert>
```

### Markdown in components

To use Markdown inside a component, add an empty line before and after the content that you pass inside:

```hbs [content/newsletter-1.md]
---
title: "Edition #1"
---

<x-alert>

  # {{ page.title }}

  This is the first newsletter.

</x-alert>
```

To prevent an issue with code indentation in `markdown-it` that would result in `<pre>` tags being added to the rendered HTML, simply don't indent the closing tags after `<yield />`. A bit of a workaround, but it works:

```html [components/alert.html]
<table class="w-full mb-8">
  <tr>
    <td
      attributes
      class="py-2 px-4 bg-blue-100 text-blue-600 rounded"
    >
      <yield />
</td>
</tr>
</table>
```

Alternatively, you may use the `prettify` transformer to remove the indentation:

```js [config.js]
import { prettify } from '@maizzle/framework'

export default {
  afterRender(html) {
    return prettify(html, {
      indent_size: 0,
    })
  }
}
```

## Custom layouts

You may need to use different designs for your newsletters. We can use Front Matter to do this, by defining a custom layout name for each Markdown file to use.

Go ahead and create `layouts/secondary.html` based on `main.html`.

For the purpose of this tutorial, we'll just change the body background color to differentiate it from the `main.html` layout: replace both occurrences of `bg-slate-100` with `bg-indigo-200`.

Next, update the `beforeRender` event in `config.js` to use the layout name from Front Matter:

```js [config.js]
import fm from 'front-matter'

export default {
  beforeRender(html) {
    const { attributes, body } = fm(html)
    const layout = attributes.layout || 'main'

    return `
      <x-${layout}>
        <md>${body}</md>
      </x-${layout}>`
  }
}
```

You can now specify a custom layout for each Markdown file, via Front Matter:

```md [content/newsletter-1.md]
---
layout: secondary
---

# Hello world

Welcome to our first newsletter.
```

You'll notice that the compiled HTML file at `build_production/newsletter-1.html` now has an indigo background color, which means it's using our custom layout.

## Outlook note

Your markdown may include retina-sized images that will very likely be larger in natural size than the 600px width of the layout.

By default, compiling Markdown to HTML will not add a `width` attribute to images.

While this is fine in browsers and modern email clients because you can control it through CSS, it will be an issue in Outlook for Windows: not specifying the width of an image will render it at its natural size, blowing up the layout in case of retina images.

To fix this, we can use `markdown-it-attrs` to manually add our image width in Markdown:

```md [content/newsletter-1.md]
# Hello world

Welcome to our first newsletter.

![Image description](/images/retina-image.jpg){width=600}
```

Notice how there's no space between the last `)` and the opening `{` where we specify the attribute. This ensures the attribute is added to the `img` tag, and not the `p` tag wrapping it.

## Resources

- [GitHub repository](https://github.com/maizzle/starter-markdown) for this guide
- For the new components syntax, see the Maizzle 4.4.0-beta [release notes](https://github.com/maizzle/framework/releases/tag/v4.4.0-beta.1)
- Docs for [Markdown in Maizzle](/docs/markdown)

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/guides/rss-feed.md
````
---
title: "How to create an email newsletter from an RSS feed"
description: "Learn how to use Maizzle Events and RSS parsing libraries to create an email newsletter from an (atom) RSS feed."
date: 2020-03-04
---

# How to create an email newsletter from an RSS feed

<p class="text-sm">Last updated: May 30, 2022</p>

In this tutorial, we'll use [Events](/docs/events) in Maizzle to fetch the contents of an RSS feed and display them in an HTML email newsletter.

You can [preview the final result](https://codepen.io/maizzle/pen/ExjvmdP?editors=1000) on CodePen.

## Initial setup

Let's start by creating a new Maizzle project.

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./example-rss`, and select the Default Starter.

Choose Yes when prompted to Install dependencies.

Once it finishes installing dependencies, open the project folder in your favorite editor.

### rss-parser

We'll be using [rss-parser](https://www.npmjs.com/package/rss-parser) fetch the contents of the RSS feed, so let's install it:

```sh
npm install rss-parser
```

## RSS Feed

We'll need an RSS feed to work with, so let's go with the best site for learning Laravel.

The [Laracasts](https://laracasts.com) feed is available at https://laracasts.com/feed.

Let's add that feed URL inside the `build` object in `config.js`:

```js [config.js]
export default {
  feed: {
    url: 'https://laracasts.com/feed'
  }
}
```

## Fetch Items

We can use `rss-parser` inside the [beforeCreate](/docs/events#beforecreate) event to fetch feed data.

Edit `config.js`, require `rss-parser`, and use it in the `beforeCreate` event:

```js [config.js]
import Parser from 'rss-parser'

export default {
  async beforeCreate(config) {
    // create a new Parser instance
    const parser = new Parser({
      customFields: {
        feed: ['subtitle'],
        item: ['summary']
      }
    })

    // fetch and parse the feed
    let feed = await parser.parseURL(config.feed.url)

    // store the feed data in our config
    config.feed = {
      title: feed.title,
      subtitle: feed.subtitle,
      link: feed.link,
      updated_at: feed.lastBuildDate,
      posts: feed.items
    }
  }
}
```

<Alert>The Laracasts feed contains fields that `rss-parser` does not currently return by default. We include them through the `customFields` option.</Alert>

## Date Format

We'll probably need to format the date of a feed item to something more readable than what the feed provides.

We can add a function to `config.js` and use it to format the item's date according to our audience's locale:

```js [config.js]
export default {
  formattedDate(str) {
    const date = new Date(str)
    return date.toLocaleDateString('en-US', {day: 'numeric', month: 'short', year: 'numeric'})
  }
}
```

<Alert>Tip: you could set `'en-US'` dynamically, based on your subscriber's preference.</Alert>

## Template

We'll use a simplified version of the [promotional template](https://github.com/maizzle/maizzle/blob/master/emails/promotional.html) from the Starter, displaying posts as full width cards.

### Header

Let's update the existing header row:

```hbs [emails/promotional.html]
<!-- ... -->
<tr>
  <td class="p-12 sm:py-8 sm:px-6 text-center">
    <a href="https://laracasts.com">
      <img src="laracasts-logo.png" width="157" alt="{{ page.feed.title }}">
    </a>
    <p class="m-0 mt-2 text-sm text-slate-600">
      {{ page.feed.subtitle }}
    </p>
  </td>
</tr>
```

### Items Loop

Let's use a full width card from the [promotional template](https://github.com/maizzle/maizzle/blob/master/emails/promotional.html) to show a list of all items from the feed:

```hbs [emails/promotional.html]
<!-- ... -->
<each loop="post in page.feed.posts">
  <tr>
    <td class="p-6 bg-white hover:shadow-xl rounded transition-shadow duration-300">
      <p class="m-0 mb-1 text-sm text-slate-500">
        {{ page.formattedDate(post.pubDate) }}
      </p>

      <h2 class="m-0 mb-4 text-2xl leading-6">
        <a href="{{ post.link }}" class="text-slate-800 hover:text-slate-700 [text-decoration:none]">
          {{ post.title }}
        </a>
      </h2>

      <p class="m-0 text-base">
        <a href="{{ post.link }}" class="text-slate-500 hover:text-slate-700 [text-decoration:none]">
          {{ post.summary }}
        </a>
      </p>
    </td>
  </tr>
  <if condition="!loop.last">
    <tr>
      <td class="h-24"></td>
    </tr>
  </if>
</each>
```

That's it, run `npm run build` to generate the production-ready email template.

Take a look at the [final result on CodePen](https://codepen.io/maizzle/pen/ExjvmdP).

## Resources

- [Laracasts](https://laracasts.com/)
- [rss-parser](https://www.npmjs.com/package/rss-parser)
- [Maizzle Events](/docs/events/)
- [GitHub repository](https://github.com/maizzle/starter-rss) for this tutorial
- [CodePen preview](https://codepen.io/maizzle/pen/ExjvmdP)

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/guides/syntax-highlighting-prismjs.md
````
---
title: "How to add PrismJS syntax highlighting to HTML emails"
description: "Using PrismJS, Markdown fenced code blocks, and Events in Maizzle to add syntax highlighting to HTML emails."
date: 2020-02-05
---

# How to add PrismJS syntax highlighting to HTML emails

<p class="text-sm">Last updated: May 30, 2022</p>

If you want to show a block of code in an HTML email _and_ have it look nice, it usually involves a lot of manual work: escaping, formatting, tokenizing, styling tokens...

With Maizzle however, we can use JavaScript libraries to do that work for us 💅

## Getting started

Let's create a new Maizzle project.

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./example-syntax-highlight`, and select the Default Starter.

Choose Yes when prompted to Install dependencies.

Once it finishes installing dependencies open the project folder in your favorite code editor.

We'll be covering two different techniques:

- with PostHTML
- with Markdown

For both techniques we'll be using the [PrismJS](https://prismjs.com/) library to highlight code blocks.

## PostHTML

Using a PostHTML plugin, we can write our own `<pre><code>` markup and have the plugin highlight the contents of the `<code>` element.

### Install plugin

First, let's install the [posthtml-prism](https://github.com/posthtml/posthtml-prism) plugin, which we'll use to highlight code blocks:

```sh
npm i posthtml-prism
```

Next, add it to the plugins list in your `config.js`:

```js [config.js] {3-7}
module.exports = {
  build: {
    posthtml: { // [!code ++]
      plugins: [ // [!code ++]
        require('posthtml-prism')() // [!code ++]
      ] // [!code ++]
    } // [!code ++]
  }
}
```

### Add code block

Add a block of code in your template, like so:

```html [emails/example.html]
<x-main>
  <pre>
    <code class="language-javascript">
    function foo(bar) {
      var a = 42,
          b = 'Prism';
      return a + bar(b);
    }
    </code>
  </pre>
</x-main>
```

<Alert>Notice how we added the `language-javascript` class on the `<code>` tag - this is required in order to get language-specific syntax highlighting.</Alert>

<Alert type="warning">You need to reset the indentation of code inside the `<pre>` tag yourself - see the <a href="https://github.com/maizzle/example-syntax-highlight/blob/master/emails/posthtml.html">PostHTML example</a> in the tutorial repository.</Alert>

## Build

Run `npm run dev` to start the development server, open `http://localhost:3000/` in a browser, and navigate to the template.

You'll see something like this:

```html
function foo(bar) {
  var a = 42,
      b = 'Prism';
  return a + bar(b);
}
```

If you view the source of your page, you'll notice a lot of `<span>` tags. This means it worked, and PrismJS has tokenized our code block.

But it's not very pretty, is it? We need a theme!

## Theming

Choose one of the default themes, or see [prism-themes](https://github.com/PrismJS/prism-themes) for more.

For this tutorial, we'll go with a Tailwind adaptation the [Synthwave '84 Theme](https://marketplace.visualstudio.com/items?itemName=RobbOwen.synthwave-vscode).

Save [prism-synthwave84.css](https://raw.githubusercontent.com/maizzle/starter-prismjs/master/src/css/prism-synthwave84.css) to the `css` directory in your project, and import it into your `css/tailwind.css`:

```css
/* Tailwind CSS components */
@import "tailwindcss/components";

/**
 * @import here any custom CSS components - that is, CSS that
 * you'd want loaded before the Tailwind utilities, so the
 * utilities can still override them.
*/
@import "custom/prism-synthwave84";

/* Tailwind CSS utility classes */
@import "tailwindcss/utilities";

/* Your custom utility classes */
@import "utilities";
```

Now, running `npm run build` will yield the result we expected:

<div class="rounded-md" style="padding: 24px; margin-bottom: 24px; overflow: auto; font-family: Menlo, Consolas, monospace; font-size: 16px; text-align: left; white-space: pre; background-image: linear-gradient(to bottom, #2a2139 75%, #34294f); color: #f92aad; hyphens: none; tab-size: 2; text-shadow: 0 0 2px #100c0f, 0 0 5px #dc078e33, 0 0 10px #fff3; word-break: normal; word-spacing: normal; word-wrap: normal; background-color: #2a2139;"><span style="color: #f4eee4; text-shadow: 0 0 2px #393a33, 0 0 8px #f39f0575, 0 0 2px #f39f0575;">function</span> <span style="color: #fdfdfd; text-shadow: 0 0 2px #001716, 0 0 3px #03edf975, 0 0 5px #03edf975, 0 0 8px #03edf975;">foo</span><span style="color: #cccccc;">(</span><span style="color: #f92aad;">bar</span><span style="color: #cccccc;">)</span> <span style="color: #cccccc;">{</span>
  <span style="color: #f4eee4; text-shadow: 0 0 2px #393a33, 0 0 8px #f39f0575, 0 0 2px #f39f0575;">var</span> <span style="color:#f92aad;">a</span> <span style="color: #67cdcc;">=</span> <span style="color: #e2777a;">42</span><span style="color: #cccccc;">,</span>
      <span style="color: #f92aad;">b</span> <span style="color: #67cdcc;">=</span> <span style="color: #f87c32;">'Prism'</span><span style="color: #cccccc;">;</span>
  <span style="color: #f4eee4; text-shadow: 0 0 2px #393a33, 0 0 8px #f39f0575, 0 0 2px #f39f0575;">return</span> <span style="color: #f92aad;">a</span> <span style="color: #67cdcc;">+</span> <span style="color: #fdfdfd; text-shadow: 0 0 2px #001716, 0 0 3px #03edf975, 0 0 5px #03edf975, 0 0 8px #03edf975;">bar</span><span style="color: #cccccc;">(</span><span style="color: #f92aad;">b</span><span style="color: #cccccc;">)</span><span style="color: #cccccc;">;</span>
<span style="color: #cccccc;display:block">}</span></div>

## Markdown

Alternatively, we can also use Markdown to write fenced code blocks and have PrismJS automatically syntax-highlight them.

### Install PrismJS

First, we must install the PrismJS library:

```sh
npm i prismjs
```

### Configure Markdown

Next, we need to configure Maizzle to use PrismJS as a custom highlight function for the Markdown renderer.

We do that in `config.js`:

```js [config.js]
const Prism = require('prismjs')

module.exports = {
  markdown: {
    markdownit: {
      highlight(code, lang) {
        lang = lang || 'markup'
        return Prism.highlight(code, Prism.languages[lang], lang)
      }
    }
  }
}
```

### Fenced code block

We can now write code inside a fenced code block in our Template:

```html [emails/example.html]
<x-main>
  <md>
    ```js
    function foo(bar) {
      var a = 42,
          b = 'Prism';
      return a + bar(b);
    }
    ```
  </md>
</x-main>
```

## Compatibility

Some email clients require  extra steps in order to render our code blocks properly.

### Gmail

Gmail will change our inline `white-space: pre;` to `white-space: pre-wrap;`. This results in code wrapping, instead of showing a horizontal scrollbar.

Fix it by adding the following CSS at the beginning of `prism-synthwave84.css`:

```css [css/prism-synthwave84.css]
pre {
  @apply whitespace-pre;
}
```

### Outlook

Padding on `<pre>` doesn't work in Outlook.

We can fix this by wrapping `<pre>` inside a table that we only show in Outlook. We then style this table inline, like so:

```html [emails/example.html]
<x-main>
  <!--[if mso]>
  <table style="width:100%;">
    <tr>
      <td style="background: #2a2139; padding: 24px;">
  <![endif]-->
  <pre>
    <code class="language-javascript">
    function foo(bar) {
      var a = 42,
          b = 'Prism';
      return a + bar(b);
    }
    </code>
  </pre>
  <!--[if mso]></td></tr></table><![endif]-->
</x-main>
```

## Production build

We've been developing locally so far, configuring PostHTML or Markdown in `config.js`. This means CSS isn't inlined, and most email optimizations are off.

When you're satisfied with the dev preview, run `npm run build` and use the template inside the `build_production/` directory for sending the email.

## Resources

- [GitHub repository](https://github.com/maizzle/starter-prismjs) for this tutorial
- [posthtml-prism](https://github.com/posthtml/posthtml-prism) plugin
- [PrismJS](https://prismjs.com/) library
- [Synthwave '84](https://github.com/PrismJS/prism-themes/blob/master/themes/prism-synthwave84.css) theme

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/guides/wordpress-api.md
````
---
title: "Using the WordPress API to create a newsletter from your posts"
description: "Learn how to use the WordPress API and Maizzle to create an HTML email newsletter with your latest posts."
date: 2020-03-02
---

# Using the WordPress API to create a newsletter from your posts

<p class="text-sm">Last updated: May 30, 2022</p>

Learn how to use Maizzle to fetch content from an API endpoint, process it, and display it in an HTML email newsletter.

You may [preview the final result](https://codepen.io/maizzle/pen/wvaeOVM?editors=1000) on CodePen.

## Initial setup

As always, let's start by creating a new Maizzle project.

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./example-wordpress`, and select the Default Starter.

Choose Yes when prompted to Install dependencies.

Once it finishes installing dependencies, open the project folder in your favorite editor.

## WordPress API

Instead of imagining abstract APIs and how you'd interact with them, let's work with a real one so you can actually follow along and test things out yourself.

Given its popularity, we'll be using the [WordPress REST API](https://developer.wordpress.org/rest-api/) in our example. We'll also need to fetch data from a real blog, so let's use the wonderful [CSS-Tricks](https://css-tricks.com).

The WordPress API on CSS-Tricks is available at https://css-tricks.com/wp-json/wp/v2/

Click that link and you'll see the various routes you can access.

### `/posts` route

We can fetch posts from the `/posts` route:

https://css-tricks.com/wp-json/wp/v2/posts/

We can also use [query string parameters](https://developer.wordpress.org/rest-api/reference/posts/#arguments) in order to refine our API call.

For example, this only asks for the 3 latest posts:

https://css-tricks.com/wp-json/wp/v2/posts?page=1&per_page=3&_embed=1

<Alert>`_embed=1` is a request scope that adds a few more fields to the response. We use it to include `_embedded["wp:featuredmedia"]`.</Alert>

## Fetch posts

Let's use the `<fetch>` tag to fetch posts from the CSS-Tricks WordPress API.

```html [emails/example.html]
<x-main>
  <fetch url="https://css-tricks.com/wp-json/wp/v2/posts?page=1&per_page=6&_embed=1">
    <!-- Posts are now available in {{ response }} -->
  </fetch>
</x-main>
```

## Use in Template

`promotional.html` in Maizzle displays 6 articles in four different layouts. Above, we're also fetching the latest 6 articles from CSS-Tricks, so it's a perfect fit ✌

### Featured Post

Let's update the Hero with background image to show the first post.

Our code becomes:

```hbs [emails/example.html]
---
bodyClass: bg-gray-200
title: "Latest posts on CSS-Tricks"
preheader: "👀 Lorem, ipsum, and much dolor in this week's edition"
---

<x-main>
  <fetch url="https://css-tricks.com/wp-json/wp/v2/posts?page=1&per_page=6&_embed=1">
    <!-- ... existing template markup before the HERO <tr> -->
    <tr>
      <td class="bg-top bg-no-repeat bg-cover rounded text-left" style="background-image: url('{{ response[0]._embedded['wp:featuredmedia'][0]['source_url'] || 'https://via.placeholder.com/600x400' }}');">
        <!--[if mso]>
        <v:image src="{{ response[0]._embedded['wp:featuredmedia'][0]['source_url'] || 'https://via.placeholder.com/600x400' }}" xmlns:v="urn:schemas-microsoft-com:vml" style="width:600px;height:400px;" />
        <v:rect fill="false" stroke="false" style="position:absolute;width:600px;height:400px;">
        <v:textbox inset="0,0,0,0"><div><![endif]-->
        <div class="leading-8">&zwj;</div>
        <table class="w-full">
          <tr>
            <td class="w-12 sm:w-4"></td>
            <td>
              <h1 class="m-0 mb-4 text-4xl text-white sm:leading-10">
                {{ response[0].title.rendered }}
              </h1>
              <div class="m-0 text-white text-lg leading-6">
                {{ response[0].excerpt.rendered }}
              </div>
              <div class="leading-8">&zwj;</div>
              <table>
                <tr>
                  <th class="bg-indigo-800 hover:bg-indigo-700 rounded" style="mso-padding-alt: 16px 24px;">
                    <a href="{{ response[0].link }}" class="block font-semibold text-white text-base leading-full py-4 px-6 [text-decoration:none]">Read more &rarr;</a>
                  </th>
                </tr>
              </table>
            </td>
            <td class="w-12 sm:w-4"></td>
          </tr>
        </table>
        <div class="leading-8">&zwj;</div>
        <!--[if mso]></div></v:textbox></v:rect><![endif]-->
      </td>
    </tr>
  </fetch>
</x-main>
```

We can use `response[index]` to output data for each post, manually. For example, we would use `response[1].title.rendered` to show the title of the second post.

### Post dates

We can add a function to `config.js` and use it to format the post's date according to our audience's locale:

```js [config.js]
module.exports = {
  formattedDate(str) {
    const date = new Date(str)
    return date.toLocaleDateString('en-US', {day: 'numeric', month: 'short', year: 'numeric'})
  }
}
```

We can then display it in the template with an expression like this:

```hbs
{{ page.formattedDate(response[1].date) }}
```

### Looping

We can use the `<each>` tag in Maizzle to loop over each item in the `response`:

```hbs
<fetch url="https://css-tricks.com/wp-json/wp/v2/posts?page=1&per_page=6&_embed=1">
  <each loop="post in response">
    {{ post.title.rendered }}
  </each>
</fetch>
```

Want to loop over a specific subset only? You can use [expressions](/docs/templates#expressions).

For example, let's show the last 2 posts in a list format at the end of the template:

```hbs [emails/example.html]
<x-main>
  <fetch url="https://css-tricks.com/wp-json/wp/v2/posts?page=1&per_page=6&_embed=1">
    <h3 class="m-0 text-base font-semibold text-gray-500 uppercase">From the archives</h3>
    <div class="leading-6">&zwj;</div>
    <table class="w-full">
      <each loop="post in response.slice(-2)">
        <tr>
          <td>
            <p class="text-xs text-gray-500 mb-0.5">
              {{ page.formattedDate(post.date) }}
            </p>
            <h4 class="m-0 mb-1 text-xl font-semibold">
              <a href="{{ post.link }}" class="text-blue-500 hover:text-blue-400 [text-decoration:none]">
                {{ post.title.rendered }}
              </a>
            </h4>
            <div class="m-0 text-gray-500">
              {{ post.excerpt.rendered }}
            </div>
            <if condition="loop.last">
              <table class="w-full">
                <tr>
                  <td class="py-6">
                    <div class="bg-gray-300 h-px leading-px">&zwj;</div>
                  </td>
                </tr>
              </table>
            </if>
          </td>
        </tr>
      </each>
    </table>
  </fetch>
</x-main>
```

Notes:

- we also added the post date in a paragraph above the title
- we're using [`loop` meta](/docs/tags#loop-meta) to output the divider only _between_ list items

## Conclusion

All that we've done in this tutorial is to:

1. Use the `<fetch>` tag to fetch JSON data from an API endpoint
2. Use that data in a Maizzle template

So this isn't tied to WordPress: it was used as an example because of its convenient API, but you're free to implement it with any other APIs.

Some ideas:

- use your CMS as an authoring system for your newsletter's content
- show the latest products from your store
- include data from [public APIs](https://github.com/public-apis/public-apis)

## Resources

- [CSS-Tricks](https://css-tricks.com)
- [Maizzle Events](/docs/events)
- [WordPress REST API](https://developer.wordpress.org/rest-api/)
- [GitHub repository](https://github.com/maizzle/starter-wordpress-api) for this tutorial

````
