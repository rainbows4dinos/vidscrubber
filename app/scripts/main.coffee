module = (name) ->
  window[name] = window[name] or {}
module "transport"

# shim for requestAnimationFrame
AnimationFrame = window.AnimationFrame
AnimationFrame.shim(20)

class transport.ImageScrubber
  @IMAGES_LOADED        = 'transport.images.loaded'
  @ON_SLIDE             = 'transport.on.slide'

  constructor: (@target) ->
    @startImg           = $('.explorer-image', @target)
    @spinnerTarget      = $('.explorer-spinner', @target)
    @framesDir          = $(@target).attr('data-frames-dir')
    @overlaysDir        = $(@target).attr('data-overlays-dir')
    @langDir            = $(@target).attr('data-lang')
    @sliderTarget       = $('.explorer-range-slider', @target)
    @canvasTarget       = document.getElementById('explorerCanvas')
    @canvasContext      = @canvasTarget.getContext('2d')
    @totalFrames        = parseInt($(@target).attr('data-frame-count')) || 24
    @targetFrame        = 1
    @currentFrame       = 1
    @imgNamePrefix      = "shoe_splodin_"
    @imageFrames        = []

    @init()

  init: ->
    @preloadImgs()

  initEvents: ->
    that = @

    # init slider widget
    @slider = document.getElementById('explorerSlider')
    noUiSlider.create @slider,
      start: 1
      connect: 'lower'
      step: 1
      range:
        'min': 1
        'max': 24

    # slider event
    @slider.noUiSlider.on 'update', (values, handle) ->
      that.targetFrame = Math.floor(values[handle])

    @play()



  activate: ->

  deactivate: ->


  play: =>
    @currentFrame += (@targetFrame - @currentFrame) / 5 unless @currentFrame == @targetFrame
    @gotoFrame(Math.floor(@currentFrame))
    @req = window.requestAnimationFrame(@play)


  pause: =>
    window.cancelAnimationFrame(@req)


  gotoFrame: (frame) ->
    console.log "current frame: #{frame}"
    return if frame <= 0
    src = @framesDir + @imgNamePrefix + frame + ".jpg"
    img = new Image()
    img.src = src
    @canvasContext.drawImage(img, 0, 0, @canvasTarget.width, @canvasTarget.height)

  preloadImgs: ->
    @spinner = new Spinner({color:'#fff', width: 2, length: 20, radius: 50, lines: 12}).spin()
    @spinnerTarget.append(@spinner.el)
    @frameSrcs = []

    for i in [1... @totalFrames+1] by 1
      src = @framesDir + @imgNamePrefix + i + ".jpg"
      @frameSrcs.push src

    @preloader = new ImagePreloader
      urls: @frameSrcs
      complete: (imageUrls) ->
        $(window).trigger(transport.ImageScrubber.IMAGES_LOADED)

    @preloader.start()

    $(window).on transport.ImageScrubber.IMAGES_LOADED, (e) =>
      @spinner.stop()
      @initEvents()


$ ->


