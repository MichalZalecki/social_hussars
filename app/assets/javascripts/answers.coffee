'use strict'

$(document).on 'page:change', ->
  $('.answer__votes__vote__link').on 'click', (e) ->
    $.when $.ajax
      method: this.dataset.method
      url: this.href + '.json'
    .then (data) =>
      votes = this.parentNode.parentNode
      votes.querySelector('.answer__votes__vote__count--upvote')
        .innerHTML = data.upvotes
      votes.querySelector('.answer__votes__vote__count--downvote')
        .innerHTML = data.downvotes

      # TODO: Make it pretty
      alert(data.message.content)

    , (data) ->
      # TODO: Make it pretty
      alert(data.responseJSON.error)


    # e.stopImmediatePropagation()
    # e.preventDefault()
    # or
    return false;

