module = (name) ->
  window[name] = window[name] or {}
module "transport"

# shim for requestAnimationFrame
window.requestAnimationFrame = do ->
  window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) ->
    window.setTimeout callback, 1000 / 60
    return

class transport.ImageScrubber
  @IMAGES_LOADED = "transport.images.loaded"


  constructor: (@target) ->
    @imageSeqImg = $('.explorer-image-seq-image', @target)
    @spinnerTarget = $('.explorer-spinner', @target)
    @framesDir = $(@target).attr('data-frames-dir')
    @overlaysDir = $(@target).attr('data-overlays-dir')
    @langDir = $(@target).attr('data-lang')

    @totalFrames = 24
    @currentFrame = 1
    @imgNamePrefix = "shoe_splodin_"

    @imageFrames = []

    @init()

  init: ->
    @initEvents()
    @preloadImgs()


  initEvents: ->


  draw: =>
    console.log 'drawing'
    @currentFrame++ unless @currentFrame == 24
    src = @framesDir + @imgNamePrefix + @currentFrame + ".jpg"
    @imageSeqImg.attr('src', src)

    window.requestAnimationFrame(@draw)



  preloadImgs: ->
    @spinner = new Spinner({color:'#fff', width: 2, length: 20, radius: 50, lines: 12}).spin()
    @spinnerTarget.append(@spinner.el)
    @frameSrcs = []
    # loop through frame images
    for i in [1... @totalFrames+1] by 1
      src = @framesDir + @imgNamePrefix + i + ".jpg"
      @frameSrcs.push src

    that = @
    @preloader = new ImagePreloader
      urls: @frameSrcs
      complete: (imageUrls) ->
        $(window).trigger(transport.ImageScrubber.IMAGES_LOADED)

    @preloader.start()

    $(window).on transport.ImageScrubber.IMAGES_LOADED, (e) =>
      console.log 'frame images loaded'
      @spinner.stop()
      @draw()
