class App.MailboxTesterRouter extends Backbone.Router
  routes:
    '': 'redirectToToday'
    'date/:year/:month/:day': 'show'

  initialize: (options) ->
    @model = options.model
    @model.bind 'change:date', @changeDate, @

  changeDate: ->
    Backbone.history.navigate @model.url.substring(1, 255), false

  redirectToToday: ->
    today = new Date()
    [year, month, day] = [today.getFullYear(), today.getMonth() + 1, today.getDate()]
    Backbone.history.navigate "date/#{year}/#{month}/#{day}"

  show: (year, month, day) ->
    @model.setDate year, month, day
    view = new App.AppView model: @model
    $('body').html view.render().el