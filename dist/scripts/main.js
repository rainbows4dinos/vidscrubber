(function(){var t,r,e=function(t,r){return function(){return t.apply(r,arguments)}};r=function(t){return window[t]=window[t]||{}},r("transport"),t=window.AnimationFrame,t.shim(20),transport.ImageScrubber=function(){function t(t){this.target=t,this.pause=e(this.pause,this),this.play=e(this.play,this),this.spinnerTarget=$(".explorer-spinner",this.target),this.framesDir=$(this.target).attr("data-frames-dir"),this.calloutsDir=$(this.target).attr("data-callouts-dir"),this.langDir=$(this.target).attr("data-lang"),this.sliderTarget=$(".explorer-range-slider",this.target),this.framesCanvas=document.getElementById("explorerFramesCanvas"),this.framesContext=this.framesCanvas.getContext("2d"),this.totalFrames=parseInt($(this.target).attr("data-frame-count"))||24,this.totalCallouts=7,this.targetFrame=1,this.currentFrame=1,this.imgNamePrefix="shoe_splodin_",this.calloutNamePrefix="callouts_",this.imageFrames=[],this.init()}return t.IMAGES_LOAD_COMPLETE="transport.images.complete",t.SVG_LOADED="transport.svg.loaded",t.SVG_LOAD_COMPLETE="transport.svg.complete",t.ON_SLIDE="transport.on.slide",t.prototype.init=function(){return this.preloadImgs()},t.prototype.initEvents=function(){var t;return t=this,this.slider=document.getElementById("explorerSlider"),noUiSlider.create(this.slider,{start:1,connect:"lower",step:1,range:{min:1,max:24}}),this.slider.noUiSlider.on("update",function(r,e){return t.targetFrame=Math.floor(r[e])}),this.play()},t.prototype.activate=function(){},t.prototype.deactivate=function(){},t.prototype.play=function(){return this.currentFrame!==this.targetFrame&&(this.currentFrame+=(this.targetFrame-this.currentFrame)/5),this.gotoFrame(Math.floor(this.currentFrame)),this.req=window.requestAnimationFrame(this.play)},t.prototype.pause=function(){return window.cancelAnimationFrame(this.req)},t.prototype.gotoFrame=function(t){var r,e;return console.log("current frame: "+t),0>=t?void 0:(e=this.framesDir+this.imgNamePrefix+t+".jpg",r=new Image,r.src=e,this.framesContext.drawImage(r,0,0,this.framesCanvas.width,this.framesCanvas.height))},t.prototype.preloadImgs=function(){var t,r,e,i;for(this.spinner=new Spinner({color:"#fff",width:2,length:20,radius:50,lines:12}).spin(),this.spinnerTarget.append(this.spinner.el),this.frameSrcs=[],t=r=1,e=this.totalFrames+1;e>r;t=r+=1)i=this.framesDir+this.imgNamePrefix+t+".jpg",this.frameSrcs.push(i);return this.framesPreloader=new ImagePreloader({urls:this.frameSrcs,complete:function(t){return $(window).trigger(transport.ImageScrubber.IMAGES_LOAD_COMPLETE)}}),this.framesPreloader.start(),$(window).on(transport.ImageScrubber.IMAGES_LOAD_COMPLETE,function(t){return function(r){return console.log("images loaded"),t.preloadSvgs()}}(this))},t.prototype.preloadSvgs=function(){var t,r,e,i;for(this.svgSrcs=[],t=r=1,e=this.totalCallouts+1;e>r;t=r+=1)i=this.calloutsDir+this.langDir+this.calloutNamePrefix+t+".svg",this.svgSrcs.push(i);return this.svgPreloader=new ImagePreloader({urls:this.svgSrcs,imageLoad:function(t){return $(window).trigger(transport.ImageScrubber.SVG_LOADED)},complete:function(t){return $(window).trigger(transport.ImageScrubber.SVG_LOAD_COMPLETE)}}),this.svgPreloader.start(),$(window).on(transport.ImageScrubber.SVG_LOADED,function(t){return function(t){}}(this)),$(window).on(transport.ImageScrubber.SVG_LOAD_COMPLETE,function(t){return function(r){return console.log("svgs loaded"),t.spinner.stop(),t.initEvents()}}(this))},t}()}).call(this);