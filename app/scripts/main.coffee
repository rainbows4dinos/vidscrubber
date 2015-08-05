module = (name) ->
  window[name] = window[name] or {}
module "transport"

# shim for requestAnimationFrame
window.requestAnimationFrame = do ->
  window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) ->
    window.setTimeout callback, 1000 / 60
    return

class transport.ImageScrubber

  constructor: (@target) ->
    @imageSeqImg = $('.explorer-image-seq-image', @target)
    @framesDir = $(@target).attr('data-frames-dir')
    @overlaysDir = $(@target).attr('data-overlays-dir')
    @langDir = $(@target).attr('data-lang')

    @totalFrames = 24
    @imgNamePrefix = "shoe_splodin_"

    @imageFrames = []

    @init()

  init: ->
    @preloadImgs()


  draw: =>
    console.log 'drawing'
    window.requestAnimationFrame(@draw)

  preloadImgs: ->
    frameSrcs = []
    # loop through frame images
    for i in [1... @totalFrames+1] by 1
      # img = new Image()
      # img.src = @framesDir + @imgNamePrefix + i + ".jpg"
      # @imageFrames.push(img)
      src = @framesDir + @imgNamePrefix + i + ".jpg"
      frameSrcs.push src

    console.log frameSrcs
    that = @
    preloader = new ImagePreloader(
      urls: frameSrcs
      imageLoad: (imageDetails) ->
        console.log imageDetails
      complete: (imageUrls) ->
        console.log "complete"
        # how?
        # that.preloadCompleted(imageUrls)
    )
    preloader.start()

    console.log preloader

  preloadCompleted: (imageUrls) ->
    console.log complete
    console.log imageUrls











$ ->
  scrubber = new transport.ImageScrubber($('#nikeAirZoomExplorer'))


  # draw = ->
  #   console.log '??'
  #   requestAnimationFrame(draw)

  # draw()