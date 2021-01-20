define ['jquery', 'config', 'page'], ($, config, Page) ->
  class Start extends Page
    constructor: ->
      super 'start'
      @button =
        shuffle: $ '#d5ehoq'
        partition: $ '#fh2z46'
        defaults: $ '#pequzi'

      @button.shuffle.click =>
        @brain.shuffle.open()

      @button.partition.click =>
        @brain.partition.open()

      @button.defaults.click =>
        for page in @brain.pageAr
          for input in page.inputAr
            input.reset()
        @button.defaults.addClass 'clicked'
        setTimeout (=> @button.defaults.removeClass 'clicked'), config.buttonClickedTime

    onOpen: ->
      @brain.method.set null
