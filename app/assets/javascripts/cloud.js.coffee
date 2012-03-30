# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ = jQuery
$.fn.center = -> 
  @css("position","absolute")
  @css("top", (($(window).height() - @outerHeight()) / 2) + $(window).scrollTop() + "px")
  @css("left", (($(window).width() - @outerWidth()) / 2) + $(window).scrollLeft() + "px")
  return this

$(document).ready ->
  $('#content').center()
  $(window).bind 'resize', ->
    $('#content').center()
  $('.cloud img').bind 'resize', ->
    $('#content').center()
    
