class App.DateView extends Backbone.View
  template: JST['menu']
  className: 'row'
  events:
    'click .link':      'today'
    'click a.previous': 'previousDay'
    'click a.next':     'nextDay'

  today: ->
    @model.goToToday()

  previousDay: ->
    @model.goToPreviousDate()

  nextDay: ->
    @model.goToNextDate()

  render: ->
    $(@el).html @template currentDate: @model.currentDate()
    @delegateEvents()
    @