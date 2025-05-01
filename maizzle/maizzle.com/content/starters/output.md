/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/starters/amp4email.md
````
---
title: "AMP4Email"
repository: https://github.com/maizzle/starter-amp4email.git
description: "Original, free AMP4EMAIL templates."
image: https://res.cloudinary.com/maizzle/image/upload/q_auto:best/starters/amp4email.jpg
htmlPreview: https://raw.githubusercontent.com/maizzle/starter-amp4email/master/build_production/carousel.html
date: 2020-02-20
---

# ⚡4email templates

Original, free ⚡4email templates built with Tailwind CSS in Maizzle.

[View on GitHub &rarr;](https://github.com/maizzle/starter-amp4email.git)

## Getting started

Scaffold a new project based on this starter:

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./amp-emails`, select Custom Starter → AMP4Email, and choose Yes when prompted to Install dependencies.

Next, switch the current directory to `amp-emails`:

```sh no-copy
cd amp-emails
```

Start local development:

```sh
npm run dev
```

Build emails for production:

```sh
npm run build
```

## Templates

The following templates are included:

- Accordion
- Carousel

## Tailwind CSS

AMP templates don't allow inline CSS, so `important` is set to `false`  in `tailwind.config.js`. Because of that, this Starter also uses an `md` screen and a mobile-first strategy instead of the default desktop-first approach from Maizzle.

## AMP Components

For each component that you want to use in a template, you need to add its script to the `<head>`. We can push to the `head` stack from the Template:

```xml [emails/accordion.html]
<x-main>
  <push name="head">
    <script async custom-element="amp-accordion" src="https://cdn.ampproject.org/v0/amp-accordion-0.1.js"></script>
  </push>

  <!-- ...  -->
</x-main>
```

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/starters/litmus.md
````
---
title: "Litmus"
repository: https://github.com/maizzle/starter-litmus.git
description: "The free email templates by Litmus."
image: https://res.cloudinary.com/maizzle/image/upload/v1586366098/starters/litmus.jpg
date: 2019-11-26
---

# Litmus starter

The free email templates by Litmus, re-built with Tailwind CSS in Maizzle.

[View on GitHub &rarr;](https://github.com/maizzle/starter-litmus.git)

## Getting started

Scaffold a new project based on this starter:

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./litmus-emails`, select Custom Starter → Git, type in `maizzle/starter-litmus` and confirm with Enter key. Then, choose Yes when prompted to Install dependencies.

Next, switch the current directory to `litmus-emails`:

```sh no-copy
cd litmus-emails
```

Start local development:

```sh
npm run dev
```

Build emails for production:

```sh
npm run build
```

## Templates

The following templates are included:

### Slate

- Newsletter
- Product Update
- Receipt
- Simple Announcement
- Stationery

### Ceej

- Account Update
- Expired Card
- Password Reset
- New Account
- Closed Account

Each Ceej template comes in 3 versions:

- HTML
- MailChimp
- Campaign Monitor

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/starters/mailchimp.md
````
---
title: "Mailchimp"
repository: https://github.com/maizzle/starter-mailchimp.git
description: "Create ready-to-upload .zip template archives for Mailchimp."
image: https://res.cloudinary.com/maizzle/image/upload/starters/mailchimp.jpg
date: 2023-08-04
---

# Mailchimp starter

This starter shows how to use events in Maizzle to automate the creation of ready-to-upload template .zip files for Mailchimp.

[View on GitHub &rarr;](https://github.com/maizzle/starter-mailchimp.git)

See our guide for more information:

[Automating Mailchimp template zip packaging with Maizzle](https://maizzle.com/guides/mailchimp-package)

## Getting started

Scaffold a new project based on this starter:

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./mailchimp-project`, select Custom Starter → Mailchimp, and choose Yes when prompted to Install dependencies.

Next, switch the current directory to `mailchimp-project`:

```sh no-copy
cd mailchimp-project
```

Start local development:

```sh
npm run dev
```

Build emails for production:

```sh
npm run build
```

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/starters/markdown.md
````
---
title: "Markdown"
repository: https://github.com/maizzle/starter-markdown.git
description: "Create emails from markdown files."
image: https://res.cloudinary.com/maizzle/image/upload/starters/markdown.jpg
date: 2022-12-05
---

# Markdown starter

This starter allows you to create emails from markdown files.

Simply add your markdown files to `content`, run the build command, and they will be converted to HTML emails using a predefined layout.

[View on GitHub &rarr;](https://github.com/maizzle/starter-markdown.git)

## Getting started

Scaffold a new project based on this starter:

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./my-project`, select Custom Starter → Markdown, and choose Yes when prompted to Install dependencies.

Next, switch the current directory to `my-project`:

```sh no-copy
cd my-project
```

Start local development:

```sh
npm run dev
```

Build emails for production:

```sh
npm run build
```

## Custom layouts

The starter supports custom layouts, which you can add to `layouts`.

The default layout is `layouts/main.html`, but if you want to use a different layout for a specific markdown file, you can add a `layout` property to its front matter:

```md [content/example.md]
---
layout: secondary
---

## Custom layout

This email uses a custom layout, defined in `layouts/secondary.html`.
```

## Customization

See the detailed guide for the Markdown starter [here](/guides/markdown-emails/).

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/starters/netlify-identity.md
````
---
title: "Netlify Identity"
repository: https://github.com/maizzle/starter-netlify-identity.git
description: "Netlify Identity HTML email templates."
image: https://res.cloudinary.com/maizzle/image/upload/v1587739921/starters/starter-netlify-identity.jpg
date: 2019-04-03
---

# Netlify Identity

Netlify Identity HTML email templates, re-built with Tailwind CSS in Maizzle.

[View on GitHub &rarr;](https://github.com/maizzle/starter-netlify-identity.git)

## Getting started

Scaffold a new project based on this starter:

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./netlify-emails`, select Custom Starter → Git, type in `maizzle/starter-netlify-identity` and confirm with Enter key. Then, choose Yes when prompted to Install dependencies.

Next, switch the current directory to `netlify-emails`:

```sh no-copy
cd netlify-emails
```

Start local development:

```sh
npm run dev
```

Build emails for production:

```sh
npm run build
```

## Templates

The following templates are included:

- Invitation
- Confirmation
- Email Change
- Password Recovery

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/starters/postmark.md
````
---
title: "Postmark"
repository: https://github.com/maizzle/starter-postmark.git
description: "Postmark's transactional email templates."
image: https://res.cloudinary.com/maizzle/image/upload/v1587739736/starters/starter-postmark.jpg
date: 2019-11-21
---

# Postmark starter

Postmark's transactional email templates, re-built with Tailwind CSS in Maizzle.

[View on GitHub &rarr;](https://github.com/maizzle/starter-postmark.git)

## Getting started

Scaffold a new project based on this starter:

```sh
npx create-maizzle
```

In the interactive setup wizard, specify the directory name to create the project in, i.e. `./postmark-emails`, select Custom Starter → Git, type in `maizzle/starter-postmark` and confirm with Enter key. Then, choose Yes when prompted to Install dependencies.

Next, switch the current directory to `postmark-emails`:

```sh no-copy
cd postmark-emails
```

Start local development:

```sh
npm run dev
```

Build emails for production:

```sh
npm run build
```

## Variations

Each template comes in three layout variations: Basic, Basic full, and Plain. This gives you a starting point to customize them to match your brand.

## Dark Mode

The templates support dark mode where available.

## Customization

This starter defines a `company` object in `config.js`, so you can quickly update company info in one place:

```js [config.js]
module.exports = {
  company: {
    name: '[Company Name, LLC]',
    address: `
    <br>1234 Street Rd.
    <br>Suite 1234
    `,
    product: '[Product Name]',
    sender: '[Sender Name]',
  },
}
```

You can preserve the `{{ }}` curly braces to use with Postmark variables by writing them as `@{{ }}` in Maizzle - see the [ignoring expressions docs](/docs/templates#ignoring-expressions).

````
