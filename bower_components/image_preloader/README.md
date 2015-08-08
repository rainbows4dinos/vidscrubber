Simple javascript class for preloading images.

## Usage

```javascript
var preloader = new ImagePreloader({
  urls: ['array', 'of', 'image', 'urls'], // URLs can be relative or absolute
  imageLoad: function(imageDetails) { ... },
  complete: function(imageUrls) { ... }
});
preloader.start();
```

The optional callbacks are:

#### `imageLoad`

Fired when an image finishes loading. Provides an `imageDetails` hash containing:

```javascript
{
  url: 'url-of-image',
  loadedCount: 2, // how many images have been loaded so far
  totalCount: 4, // total image count
  abort: false, // true if image load was aborted
  error: false // true if image load encountered error
}
```

#### `complete`

Fired when all images have finished loading. Provides an array of the image URLs.

## Example

http://6.github.com/image_preloader.js/example.html

## Credits

Loosely based off image preloader gist by eikes: [https://gist.github.com/eikes/3925183](https://gist.github.com/eikes/3925183)
