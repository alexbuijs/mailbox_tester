class App.OverView extends Backbone.View
  template: JST['overview']
  className: 'row overview'
  events:
    'click .btn.show-messages': 'showDetails'

  showDetails: ->
    if $('.row.details').length == 1
      $('.row.details').toggle()
      @text = if $('.row.details:visible').length == 1 then 'Verberg' else 'Toon'
    else if @model.get('totalMismatches') > 1
      details = new App.DetailsView date: @model.currentDate()
      $('.container').append details.render().el
      @text = 'Verberg'
    $('.btn.show-messages').show().text(@text + ' mismatches') if @text

  render: ->
    $(@el).html @template statistics: @model
    @delegateEvents()
    @