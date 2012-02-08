class App.MessageView extends Backbone.View
  template: JST['message']
  tagName: 'tr'
  events:
    'click a.compare': 'compare'

  compare: ->
    @result = @model.get('message_id')
    @prd_message = new App.PrdMessage(id: @result)
    @acc_message = new App.AccMessage(id: @result)
    view = new App.CompareView result: @result, prd_message: @prd_message, acc_message: @acc_message
    @prd_message.fetch()
    @acc_message.fetch()

  render: ->
    $(@el).html @template message: @model
    @