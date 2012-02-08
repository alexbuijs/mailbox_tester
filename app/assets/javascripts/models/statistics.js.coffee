class App.Statistics extends Backbone.Model
  setDate: (year, month, day) ->
    # Call with a year, a 1-indexed month, and day of month. Or just a Date object.
    if month is undefined and day is undefined
      date = year
      [year, month, day] = [date.getFullYear(), date.getMonth() + 1, date.getDate()]
    [@year, @month, @day] = [year, month, day]
    @url = "/date/#{year}/#{month}/#{day}"
    @fetch()
    @trigger 'change:date'

  currentDate: ->
    new Date(@year, @month - 1, @day)

  goToToday: ->
    @setDate new Date()

  goToPreviousDate: ->
    date = @currentDate()
    date.setDate(@currentDate().getDate() - 1)
    @setDate date

  goToNextDate: ->
    date = @currentDate()
    date.setDate(@currentDate().getDate() + 1)
    @setDate date