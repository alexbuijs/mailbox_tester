class App.DetailsView extends Backbone.View
  template: JST['details']
  className: 'row details'

  initialize: (options) ->
    date = options.date
    @messages = new App.Messages(date)
    @messages.bind 'reset', @render, @
    @messages.fetch()

  render: ->
    $(@el).html @template()
    @renderMessages @messages
    @

  renderMessages: (messages) ->
    @.$('table tbody').empty()
    for message in messages.models
      view = new App.MessageView(model: message)
      @.$('table tbody').append view.render().el