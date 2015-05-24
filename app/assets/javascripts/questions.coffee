'use strict'

$(document).on 'page:change', ->
  $('.questions-container').masonry
    itemSelector: '.question'
