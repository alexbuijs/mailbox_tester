window.App =
  init: ->
    @statistics = new App.Statistics()
    @router = new App.MailboxTesterRouter model: @statistics
    Backbone.history.start pushState: true