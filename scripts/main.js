(function(){var t,r=function(t,r){return function(){return t.apply(r,arguments)}};t=function(t){return window[t]=window[t]||{}},t("transport"),window.requestAnimationFrame=function(){return window.requestAnimationFrame||window.webkitRequestAnimationFrame||window.mozRequestAnimationFrame||window.oRequestAnimationFrame||window.msRequestAnimationFrame||function(t){window.setTimeout(t,1e3/60)}}(),transport.ImageScrubber=function(){function t(t){this.target=t,this.draw=r(this.draw,this),this.imageSeqImg=$(".explorer-image-seq-image",this.target),this.spinnerTarget=$(".explorer-spinner",this.target),this.framesDir=$(this.target).attr("data-frames-dir"),this.overlaysDir=$(this.target).attr("data-overlays-dir"),this.langDir=$(this.target).attr("data-lang"),this.sliderTarget=$(".explorer-range-slider",this.target),this.totalFrames=parseInt($(this.target).attr("data-frame-count"))||24,this.previousFrame=0,this.currentFrame=1,this.imgNamePrefix="shoe_splodin_",this.imageFrames=[],this.init()}return t.IMAGES_LOADED="transport.images.loaded",t.ON_SLIDE="transport.on.slide",t.prototype.init=function(){return this.preloadImgs()},t.prototype.initEvents=function(){var t;return this.slider=document.getElementById("explorerSlider"),noUiSlider.create(this.slider,{start:1,connect:"lower",step:1,range:{min:1,max:24}}),t=this,this.slider.noUiSlider.on("update",function(r,e){return console.log("value: "+r[e]),t.currentFrame=Math.floor(r[e]),t.gotoFrame()})},t.prototype.draw=function(){return this.currentFrame!==this.totalFrames&&this.currentFrame++,window.requestAnimationFrame(this.draw)},t.prototype.gotoFrame=function(){var t;return console.log(this.currentFrame),this.currentFrame<=0?void 0:(t=this.framesDir+this.imgNamePrefix+this.currentFrame+".jpg",this.imageSeqImg.attr("src",t))},t.prototype.preloadImgs=function(){var t,r,e,i;for(this.spinner=new Spinner({color:"#fff",width:2,length:20,radius:50,lines:12}).spin(),this.spinnerTarget.append(this.spinner.el),this.frameSrcs=[],t=r=1,e=this.totalFrames+1;e>r;t=r+=1)i=this.framesDir+this.imgNamePrefix+t+".jpg",this.frameSrcs.push(i);return this.preloader=new ImagePreloader({urls:this.frameSrcs,complete:function(t){return $(window).trigger(transport.ImageScrubber.IMAGES_LOADED)}}),this.preloader.start(),$(window).on(transport.ImageScrubber.IMAGES_LOADED,function(t){return function(r){return t.spinner.stop(),t.initEvents()}}(this))},t}(),$(function(){})}).call(this);