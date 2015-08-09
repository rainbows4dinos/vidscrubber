module = (name) ->
  window[name] = window[name] or {}
module "transport"

# shim for requestAnimationFrame
AnimationFrame = window.AnimationFrame
AnimationFrame.shim(20)

class transport.ImageScrubber
  @IMAGES_LOAD_COMPLETE       = 'transport.images.complete'
  @SVG_LOADED                 = 'transport.svg.loaded'
  @SVG_LOAD_COMPLETE          = 'transport.svg.complete'

  @ON_SLIDE             = 'transport.on.slide'

  constructor: (@target) ->
    @spinnerTarget      = $('.explorer-spinner', @target)
    @framesDir          = $(@target).attr('data-frames-dir')
    @calloutsDir        = $(@target).attr('data-callouts-dir')
    @langDir            = $(@target).attr('data-lang')
    @sliderTarget       = $('.explorer-range-slider', @target)
    @framesCanvas       = document.getElementById('explorerFramesCanvas')
    @framesContext      = @framesCanvas.getContext('2d')

    @totalFrames        = parseInt($(@target).attr('data-frame-count')) || 24
    @totalCallouts      = 7
    @targetFrame        = 1
    @currentFrame       = 1
    @imgNamePrefix      = 'shoe_splodin_'
    @calloutNamePrefix  = 'callouts_'
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
    src = @framesDir + @imgNamePrefix + frame + '.jpg'
    img = new Image()
    img.src = src
    @framesContext.drawImage(img, 0, 0, @framesCanvas.width, @framesCanvas.height)

  preloadImgs: ->
    @spinner = new Spinner({color:'#fff', width: 2, length: 20, radius: 50, lines: 12}).spin()
    @spinnerTarget.append(@spinner.el)
    @frameSrcs = []

    for i in [1... @totalFrames+1] by 1
      src = @framesDir + @imgNamePrefix + i + '.jpg'
      @frameSrcs.push src

    @framesPreloader = new ImagePreloader
      urls: @frameSrcs
      complete: (imageUrls) ->
        $(window).trigger(transport.ImageScrubber.IMAGES_LOAD_COMPLETE)

    @framesPreloader.start()

    $(window).on transport.ImageScrubber.IMAGES_LOAD_COMPLETE, (e) =>
      # next, load the callouts
      console.log "images loaded"
      @preloadSvgs()

  preloadSvgs: ->
    @svgSrcs = []
    for i in [1... @totalCallouts+1] by 1
      src = @calloutsDir + @langDir + @calloutNamePrefix + i + '.svg'
      @svgSrcs.push src

    @svgPreloader = new ImagePreloader
      urls: @svgSrcs
      imageLoad: (imageDetails) ->
        $(window).trigger(transport.ImageScrubber.SVG_LOADED)
      complete: (imageUrls) ->
        $(window).trigger(transport.ImageScrubber.SVG_LOAD_COMPLETE)

    @svgPreloader.start()

    $(window).on transport.ImageScrubber.SVG_LOADED, (e) =>
      # create li -> svg elements for each svg

    $(window).on transport.ImageScrubber.SVG_LOAD_COMPLETE, (e) =>
      # frames and callouts loaded, start animation
      console.log "svgs loaded"
      @spinner.stop()
      @initEvents()
