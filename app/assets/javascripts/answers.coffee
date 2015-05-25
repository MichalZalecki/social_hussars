'use strict'

$(document).on 'page:change', ->
  modal = $('.answer-modal');
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

      unless data.message.type == 'success'
        modal.find('p').html(data.message.content)
        modal.modal()

    , (data) ->
      modal.find('p').html(data.responseJSON.error)
      modal.modal()


    # e.stopImmediatePropagation()
    # e.preventDefault()
    # or
    return false;

