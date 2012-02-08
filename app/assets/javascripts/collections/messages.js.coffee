class App.Messages extends Backbone.Collection
  model: App.Message

  initialize: (date) ->
    @date = date

  url: ->
    "/messages/#{@date.getFullYear()}/#{@date.getMonth() + 1}/#{@date.getDate()}"