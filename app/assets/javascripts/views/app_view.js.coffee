class App.AppView extends Backbone.View
  className: 'container'

  initialize: ->
    @model.bind 'change', @render, @
    @subviews = [
      new App.DateView model: @model
      new App.MatchView model: @model
      new App.OverView model: @model
    ]

  render: ->
    $(@el).empty()
    $(@el).append subview.render().el for subview in @subviews
    @