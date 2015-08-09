module = (name) ->
  window[name] = window[name] or {}
module "transport"

# shim for requestAnimationFrame
AnimationFrame = window.AnimationFrame
AnimationFrame.shim(20)

class transport.ImageScrubber
  @IMAGES_LOAD_COMPLETE       = 'transport.images.complete'
  @SVG_LOAD_COMPLETE          = 'transport.svg.complete'

  constructor: (@target) ->
    @spinnerTarget      = $('.explorer-spinner', @target)
    @framesDir          = $(@target).attr('data-frames-dir')
    @calloutsDir        = $(@target).attr('data-callouts-dir')
    @langDir            = $(@target).attr('data-lang')
    @controlsTarget     = $('.explorer-controls', @target)
    @sliderTarget       = $('.explorer-range-slider', @controlsTarget)
    @framesCanvas       = document.getElementById('explorerFramesCanvas')
    @framesContext      = @framesCanvas.getContext('2d')
    @calloutsTarget     = $('.explorer-overlays', @target)

    @totalFrames        = Number($(@target).attr('data-frame-count')) or 24
    @totalCallouts      = 7
    @targetFrame        = 1
    @currentFrame       = 1
    @imgNamePrefix      = 'shoe_splodin_'
    @calloutNamePrefix  = 'callouts_'
    @imageFrames        = []
    @calloutItems       = []
    @calloutsInOut  = [
      {in: '2', out: '5'},
      {in: '5', out: '8'},
      {in: '8', out: '11'},
      {in: '11', out: '14'},
      {in: '14', out: '17'},
      {in: '17', out: '20'},
      {in: '23', out: '24'}
    ]

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
        'max': @totalFrames

    # slider event
    @slider.noUiSlider.on 'update', (values, handle) ->
      that.targetFrame = Math.floor(values[handle])
      that.doCallout(Math.floor(values[handle]))

    @play()

  activate: ->
    @buildCallouts()
    @spinner.stop()
    @initEvents()
    @controlsTarget.fadeIn(800)

  play: =>
    @currentFrame += (@targetFrame - @currentFrame) / 5 unless @currentFrame == @targetFrame
    f = Math.floor(@currentFrame)
    @gotoFrame(f)
    @req = window.requestAnimationFrame(@play)

  pause: =>
    window.cancelAnimationFrame(@req)

  gotoFrame: (frame) ->
    # console.log "current frame: #{frame}"
    return if frame <= 0
    src = @framesDir + @imgNamePrefix + frame + '.jpg'
    img = new Image()
    img.src = src
    @framesContext.drawImage(img, 0, 0, @framesCanvas.width, @framesCanvas.height)

  doCallout: (frame) ->
    i = 0
    for obj in @calloutsInOut
      numIn = Number(obj.in)
      numOut = Number(obj.out)
      if numIn <= frame and frame <= numOut
        @calloutItems[i].fadeIn()
      else
        @calloutItems[i].fadeOut(200)
      i++

  buildCallouts: ->
    for src in @svgSrcs
      li = $("<li style='background: url(#{src}) center no-repeat; background-size: contain;'></li>")
      @calloutItems.push li
      @calloutsTarget.append(li)


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
      @preloadSvgs()

  preloadSvgs: ->
    @svgSrcs = []
    for i in [1... @totalCallouts+1] by 1
      src = @calloutsDir + @langDir + @calloutNamePrefix + i + '.svg'
      @svgSrcs.push src

    @svgPreloader = new ImagePreloader
      urls: @svgSrcs
      complete: (imageUrls) ->
        $(window).trigger(transport.ImageScrubber.SVG_LOAD_COMPLETE)

    @svgPreloader.start()

    $(window).on transport.ImageScrubber.SVG_LOAD_COMPLETE, (e) =>
      # frames and callouts loaded, start animation
      @activate()
