class @ImagePreloader
  constructor: (options = {}) ->
    @loadedCount = 0
    {@urls, @imageLoad, @complete} = options

  start: =>
    _this = @
    for imageUrl in (@urls || [])
      image = new Image()
      image.onabort = -> _this.onImageLoad(@, abort: true)
      image.onerror = -> _this.onImageLoad(@, error: true)
      image.onload = -> _this.onImageLoad(@)
      image.src = imageUrl

  onImageLoad: (image, attributes = {}) =>
    @loadedCount += 1
    details =
      url: image.src
      loadedCount: @loadedCount
      totalCount: @urls.length
      abort: !!attributes.abort
      error: !!attributes.error
    @imageLoad?(details)

    if @loadedCount >= @urls.length
      @complete?(@urls)
