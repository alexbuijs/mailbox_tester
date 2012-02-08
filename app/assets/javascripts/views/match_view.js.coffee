class App.MatchView extends Backbone.View
  template: JST['match']
  className: 'row'
  events:
    'click a': 'matchMessages'

  matchMessages: ->
    $('.match.btn').hide()
    $('.row.overview').html('')
    $('.row.details').html('')
    $('.alert').show()
    date = @model.currentDate()
    [year, month, day] = [date.getFullYear(), date.getMonth() + 1, date.getDate()]
    $.post "/match/#{year}/#{month}/#{day}", => @model.fetch()

  render: ->
    if @model && (@model.get('totalMessages') > @model.get('totalMatches'))
      $(@el).html @template
      @delegateEvents()
    else
      $(@el).html('')
    @