class App.CompareView extends Backbone.View
  template: JST['compare']

  initialize: (options) ->
    @result = options.result
    @prd_message = options.prd_message
    @acc_message = options.acc_message
    @prd_message.bind 'change', @render, @
    @acc_message.bind 'change', @render, @

  render: ->
    $('#compare-modal').html @template id: @result, prd: @prd_message, acc: @acc_message
    $('#compare-modal').modal()
    @