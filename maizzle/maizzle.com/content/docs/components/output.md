/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/docs/components/button.md
````
---
title: "Button Component"
description: "A component for creating styled link buttons to your HTML emails."
---

# Button Component

The Button component makes it easy to add a styled link button to your HTML emails.

## Usage

The Button component is defined in `components/button.html`.

This enables the `<x-button>` tag, which you can use like this:

```html [emails/example.html]
<x-button href="https://example.com">
  Book now
</x-button>
```

You can use it anywhere you'd use a `<div>`.

## Customization

You can align the Button to the left, center or right, change its CSS styling, and adjust padding for Outlook on Windows.

### Href

Default: `undefined`

If you want the Button to link somewhere, you need to pass it the `href` prop:

```html [emails/example.html]
<x-button href="https://example.com">
  Book now
</x-button>
```

<Alert>The Button still renders if you don't pass `href`, but it will not include the `href` attribute on the `<a>` tag and might look broken in some email clients because of this.</Alert>

### Align

Default: `undefined`

You can align the Button to the left, center or right, through the `align` prop:

```html [emails/example.html]
<x-button align="center">
  Book now
</x-button>
```

This will add the `text-center` class to the button's wrapper `<div>`, which will align the `<a>` inside it to the center.

### Styling

You may style the Button as needed through props or with Tailwind CSS utilities.

The button includes a <span class="inline-flex gap-1 px-2 translate-y-0.5 border border-slate-200 border-solid rounded"><span class="w-3 h-3 mt-1.5 bg-indigo-700 rounded" title="#4338ca"></span><span class="text-sm/6">bg-indigo-700</span></span> background and <span class="inline-flex gap-1 px-2 translate-y-0.5 border border-slate-200 border-solid rounded"><span class="w-3 h-3 mt-1.5 border border-solid rounded bg-slate-50" title="#f8fafc"></span><span class="text-sm/6">text-slate-50</span></span> text color by default, which you can change through props.

For example, let's make the button blue-themed:

```html [emails/example.html]
<x-button
  href="https://example.com"
  color="#fffffe"
  bg-color="#1e65e1"
>
  Book now
</x-button>
```

You can also use Tailwind CSS utilities to set the text and background colors:

```html [emails/example.html]
<x-button
  href="https://example.com"
  class="bg-blue-500 text-white"
>
  Book now
</x-button>
```

Of course, you may also change the colors directly in `components/button.html`.

### MSO Padding

Top and bottom padding for Outlook on Windows is controlled through `letter-spacing` and `mso-text-raise`, a proprietary Outlook CSS property.

This technique is based on the Link Button from [goodemailcode.com](https://www.goodemailcode.com/email-code/link-button).

#### MSO top padding

Default: `16px`

Adjust the top padding for Outlook on Windows with the `mso-pt` prop:

```html [emails/example.html]
<x-button mso-pt="12px">
  Book now
</x-button>
```

#### MSO bottom padding

Default: `31px`

Adjust the bottom padding for Outlook on Windows with the `mso-pb` prop:

```html [emails/example.html]
<x-button mso-pb="24px">
  Book now
</x-button>
```

### Other attributes

You may pass any other HTML attributes to the component, such as `data-*` or `id` - they will all be added to the `<a>` tag.

Note that non-standard attributes will be ignored by default - you'll need to define them as props in the component if you need them preserved. Alternatively, you can [safelist](/docs/configuration/components#safelistattributes) them in your `build.components` config.

## Responsive

To override Button styling on small viewports, use Tailwind CSS utilities.

For example, let's make the button full-width on small viewports:

```html [emails/example.html]
<x-button class="sm:block">
  Book now
</x-button>
```

## Alternatives

There are other ways to create buttons in your HTML emails, such as by using a `<table>`. Check out our [Button examples](/docs/examples/buttons) for more ideas.

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/docs/components/divider.md
````
---
title: "Divider Component"
description: "A component for creating horizontal visual dividers in HTML emails."
---

# Divider Component

Quickly add horizontal visual dividers to your HTML emails.

## Usage

The Divider component is defined in `components/divider.html`.

This enables the `<x-divider>` syntax, which you can use like this:

  ```html [emails/example.html] {5}
  <x-main>
    <table>
      <tr>
        <td>
          <x-divider />
        </td>
      </tr>
    </table>
  </x-main>
  ```

You can use it anywhere you'd use a `<div>`.

Simply using the `<x-divider>` tag will render a `1px` gray horizontal line with `24px` of space above and below it.

## Customization

You can customize the Divider and give it a custom height (line thickness), change its color, and adjust the space around it.

### Height

Default: `1px`

The default height is `1px`, but you can change it with the `height` prop:

```html [emails/example.html]
<x-divider height="2px" />
```

### Color

Default: `#cbd5e1`

Define a custom line color with the `color` prop. You can use any CSS color value.

If you omit this prop, the Divider will use `bg-slate-300` from Tailwind CSS, which is currently set to `#cbd5e1`.

Let's change the color to red:

```html [emails/example.html]
<x-divider color="#e53e3e" />
```

You can also use Tailwind CSS utilities if you prefer:

```html [emails/example.html]
<x-divider class="bg-rose-500" />
```

<Alert>Tailwind CSS utilities must be passed inside the `class` attribute, not the `color` attribute.</Alert>

### Margins

Default: `undefined`

Add margins to any of the four sides of the Divider, through these props:

- `top`
- `right`
- `bottom`
- `left`

For example, let's add `32px` to the top and `64px` to the bottom:

```html [emails/example.html]
<x-divider top="32px" bottom="64px" />
```

Under the hood, the CSS `margin` property is used, so you can use any CSS unit that is supported in HTML emails.

<Alert>Margin props will override `space-y|x` props.</Alert>

### Spacing

Default: `24px|undefined`

You may add top/bottom or left/right spacing through a single prop:

- `space-y` for top & bottom (default: `24px`)
- `space-x` for left & right (not set by default)

For example, let's add `32px` to the top and bottom:

```html [emails/example.html]
<x-divider space-y="32px" />
```

Similarly, let's add `24px` to the left and right:

```html [emails/example.html]
<x-divider space-x="24px" />
```

<Alert>`space-y|x` props will be overridden by individual margin props.</Alert>

### Other attributes

You may pass any other HTML attributes to the component, such as `data-*` or `id`.

Note that non-standard attributes will be ignored by default - you'll need to define them as props in the component if you need them preserved. Alternatively, you can safelist them in your `build.components` config.

## Responsive

To override Divider styling on small viewports, use Tailwind CSS utilities:

```html [emails/example.html]
<x-divider space-y="32px" class="sm:my-4 sm:bg-black" />
```

## Outlook note

The root `<div>` element of the Divider component needs some extra attention for Outlook on Windows, otherwise it will render thicker than intended.

For the Divider to render the visual line as expected in Outlook on Windows too, it should also be styled with `mso-line-height-rule: exactly`. In Maizzle, this is set globally in the `main.html` layout so you don't need to worry about it.

However, if you can't use that layout for some reason or are worried that the Outlook-specific CSS in the `<head>` might be stripped in some situations, simply add it in a style attribute on the tag:

```html [emails/example.html]
<x-divider style="mso-line-height-rule: exactly;" />
```

Alternatively, you may also use the `mso-line-height-rule-exactly` class that is available from the `tailwindcss-mso` plugin (included in the Starter):

```html [emails/example.html]
<x-divider class="mso-line-height-rule-exactly" />
```

Of course, you can also modify `components/divider.html` and add the `mso-line-height-rule: exactly` CSS rule to the `<div>` element.

## Alternatives

There are other ways to create horizontal visual dividers in your HTML emails, such as using a `<table>` or an `<hr>`. Check out our [Divider examples](/docs/examples/dividers) for more ideas.

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/docs/components/spacer.md
````
---
title: "Spacer Component"
description: "A component for creating consistent vertical spacing in HTML emails."
---

# Spacer Component

The Spacer component in Maizzle makes it super simple to add consistent, accessible vertical spacing to your HTML emails.

## Usage

The Spacer component is defined in `components/spacer.html`.

This enables the `<x-spacer>` syntax, which you can use like this:

```html {5}
<x-main>
  <table>
    <tr>
      <td>
        <x-spacer height="32px" />
      </td>
    </tr>
  </table>
</x-main>
```

You can use it anywhere you'd use a `<div>`.

If you need to add space between `<tr>`, see the [Row Spacer example](/docs/examples/spacers#row) instead.

## Props

You can pass props to the component via HTML attributes, to control its height.

### height

Default: `undefined`

This will define the height of the Spacer.

You may use any CSS unit that you prefer, it doesn't have to be `px`.

```html [emails/example.html]
<x-spacer height="1em" />
```

That will render the following HTML:

```html [emails/example.html]
<div style="line-height: 1em;" role="separator">&zwj;</div>
```

If `height` is omitted, the Spacer will render as `<div role="separator">&zwj;</div>`, which will render as an empty space that is as high as its parent element's `line-height`.

### mso-height

Default: `undefined`

Override the height of the Spacer in Outlook for Windows.

```html [emails/example.html]
<x-spacer height="32px" mso-height="30px" />
```

This uses the `mso-line-height-alt` MSO CSS property to set a custom Spacer height in Outlook for Windows.

Note: for the Spacer to work as expected in Outlook on Windows, it should also be styled with `mso-line-height-rule: exactly`. In Maizzle this is set globally in the `main.html` layout, so you don't need to worry about it.

However, if you can't use that layout for some reason or are worried that the Outlook-specific CSS in the `<head>` might be stripped in some situations, simply add it in a style attribute on the tag:

```html [emails/example.html]
<x-spacer style="mso-line-height-rule: exactly;" />
```

Alternatively, you may also use the `mso-line-height-rule-exactly` class that is available from the `tailwindcss-mso` plugin (included in the Starter):

```html [emails/example.html]
<x-spacer class="mso-line-height-rule-exactly" />
```

Of course, you can also modify `components/spacer.html` and add the `mso-line-height-rule: exactly` CSS rule to the `<div>` element.

### Other attributes

You may pass any other HTML attributes to the component, such as `class` or `id`.

Note that non-standard attributes will be ignored by default - you'll need to define them as props in the component if you need them preserved. Alternatively, you can safelist them in your `build.components` config.

## Responsive

To override the height of the Spacer on mobile, use the `leading` utilities in Tailwind CSS:

```html [emails/example.html]
<x-spacer height="32px" class="sm:leading-4" />
```

````
/Users/josh/Documents/GitHub/maizzle/maizzle.com/content/docs/components/vml.md
````
---
title: "VML Components"
description: "Components for coding background images for Outlook on Windows."
---

# VML Components

VML stands for Vector Markup Language, it is a legacy markup language that was used in Outlook for Windows.

The Maizzle Starter includes a VML component that you can use to add support for background images in Outlook for Windows.

## v-fill

The Fill component is defined in `components/v-fill.html`.

Use it when you need to add a background image that you don't know the height of.

<Alert type="warning">`v:fill` does not work in Windows 10 Mail.</Alert>

You can use it immediately inside a container that has a CSS background image:

```html {4-9}
<table>
  <tr>
    <td style="background-image: url('https://picsum.photos/600/400')">
      <x-v-fill // [!code ++]
        image="https://picsum.photos/600/400" // [!code ++]
        width="600px" // [!code ++]
      > // [!code ++]
        HTML to show on top of the image <!-- [!code ++] -->
      </x-v-fill> // [!code ++]
    </td>
  </tr>
</table>
```

That will compile to:

```html {4-9}
<table cellpadding="0" cellspacing="0" role="none">
  <tr>
    <td style="background-image: url('https://picsum.photos/600/400')">
      <!--[if mso]>
      <v:rect stroke="f" fillcolor="none" style="width: 600px" xmlns:v="urn:schemas-microsoft-com:vml">
      <v:fill type="frame" src="https://picsum.photos/600/400" />
      <v:textbox inset="0,0,0,0" style="mso-fit-shape-to-text: true"><div><![endif]-->
        HTML to show on top of the image
      <!--[if mso]></div></v:textbox></v:rect><![endif]-->
    </td>
  </tr>
</table>
```

## Props

The `x-v-fill` component supports the following props:

### image

Default: `https://via.placeholder.com/600x400`

The URL of the image that will be used as a background image in Outlook for Windows.

### width

Default: `600px`

The width of the image, preferably in pixels. This sets CSS `width` on the root `<v:rect>` VML element of the component, so you'll need to include the unit, i.e. `600px` instead of `600`.

### inset

Default: `0,0,0,0`

Replicates the CSS `padding` property.

The order of the values is `left, top, right, bottom`.

This is applied to a `<v:textbox>` element that wraps the content of the component - basically, the content that you want overlayed on top of the background image.

```html
<x-v-fill
  image="https://picsum.photos/600/400"
  width="600px"
  inset="10px,20px,10px,20px"
/>
```

### type

Default: `frame`

The type of fill to use. You can use `frame` or `tile`.

### sizes

Default: `undefined`

Define the exact dimensions of the `<v:fill>` element.

Both values need to be set and they can be separated by either a comma or a space:

```html
<x-v-fill
  image="https://picsum.photos/600/400"
  width="600px"
  sizes="300px,200px"
/>
```

### origin

Default: `undefined`

Replicates the CSS `background-position` property.

```html
<x-v-fill
  image="https://picsum.photos/600/400"
  width="600px"
  origin="0.5,0.5"
  position="0.5,0.5"
/>
```

TL;DR:

- `origin="-0.5,-0.5" position="-0.5,-0.5"` equals `top left`
- `origin="0.5,-0.5" position="0.5,-0.5"` equals `top right`
- `origin="-0.5,0.5" position="-0.5,0.5"` equals `bottom left`
- `origin="0.5,0.5" position="0.5,0.5"` equals `bottom right`

Read more [here](https://www.hteumeuleu.com/2021/background-properties-in-vml/#background-position).

### position

Default: `undefined`

See the docs for `origin` above.

### aspect

Default: `undefined`

Replicates the CSS `background-size` property.

Possible values:

- `atleast` (background-size: cover)
- `atmost` (background-size: contain)

Example:

```html
<x-v-fill
  image="https://picsum.photos/600/400"
  width="600px"
  aspect="atleast"
/>
```

### color

Default: `undefined`

Replicates the CSS `background-color` property.

Example:

```html
<x-v-fill
  image="https://picsum.photos/600/400"
  width="600px"
  color="#f8fafc"
/>
```

### fillcolor

Default: `none`

Whether to fill the shape with a color.

Example:

```html
<x-v-fill
  image="https://picsum.photos/600/400"
  width="600px"
  fillcolor="#f8fafc"
/>
```

### stroke

Default: `f`

Adds a border to the shape.

Example:

```html
<x-v-fill
  image="https://picsum.photos/600/400"
  width="600px"
  stroke="t"
/>
```

### strokecolor

Default: `undefined`

The color of the border.

Example:

```html
<x-v-fill
  image="https://picsum.photos/600/400"
  width="600px"
  stroke="t"
  strokecolor="#f8fafc"
/>
```

````
