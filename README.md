# Nike Air Zoom - Image Sequence Explorer
HTML5 image sequence scrubber with time/frame triggered overlays. It's called vidscrubber because I originally thought I was going to use a video. Duh.

View latest build:
[http://rainbows4dinos.github.io/vidscrubber/](http://rainbows4dinos.github.io/vidscrubber/)

## Using 
First, include the required `js` and `css` files into your site. 

### CSS
- `air-zoom-explorer-dependencies.css`
- `air-zoom-explorer.css`
### JS
- `air-zoom-explorer-dependencies.js`
- `air-zoom-explorer-main.js`

Most options are passed through the `data` atributes of the markup, with the exeption of an optional json file you can load in to define the animation in and out points of the callouts. 

### The Markup:
```
<div id="nikeAirZoomExplorer" class="explorer-frame"
    data-frames-dir         = "images/air_zoom_explorer/frames/"
    data-frame-count        = "24"
    data-callouts-dir       = "images/air_zoom_explorer/callouts/"
    data-callout-points-json = "json/air-zoom-explorer-callout-points.json"
    data-lang               = "eng/"
    >
    <div class="explorer-logo-overlay" style="background-image: url(images/air_zoom_explorer/logo.svg)"></div>
    <div class="explorer-spinner"></div>
    <div id="explorerSlider" class="explorer-controls"></div>
    <ul class="explorer-overlays"></ul>
    <div class="explorer-image-seq-container">
      <canvas id="explorerFramesCanvas" class="explorer-canvas" width="800" height="350"></canvas>
      <img src="images/air_zoom_explorer/frames/shoe_splodin_1.jpg" alt="Nike Air Zoom" class="explorer-default-image">
    </div>
</div>
```

### Data Attr Definitions:


|Data Attr   | Definition|
|:-----------|:----------|
|`data-frames-dir` | Path to directory containing the animation's frames. These must be `.jpg`s.|
|`data-frames-count` | Optional - # of frames in the animation, corrisponding to # of jpgs. Defaults to 24.|
|`data-callouts-dir`| Path to directory containing the callouts. Must be `.svg`s same size as animation frames.|
|`data-callout-point-json`| Optional - Path to a `.json` file defining the in and out points of each callout.|
|`data-lang`| This is the name of the sub-directory containing the callouts. Create new directories for new languages.|

## Compatibility:

| Browser       | Version      |
|:--------------|:-------------|
| IE            | 9         |
| Firefox       | 38        |
| Chrome        | 31        |
| Safari        | 7.1       |
| Opera         | 30        |
| iOS Safari    | 7.1       |
| Android       | 4.1       |
| Android Chrome| 42        |
| Opera Mini    | Pfft…     |


