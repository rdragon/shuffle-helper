define ['jquery', 'config', 'helper', 'property', 'start', 'shuffle', 'partition', 'settings', 'play'], ($, config, helper, Property, Start, Shuffle, Partition, Settings, Play) ->
  class Brain
    constructor: ->
      @propertyAr = []
      @start = new Start()
      @shuffle = new Shuffle()
      @partition = new Partition()
      @settings = new Settings()
      @play = new Play()
      @pageAr = [@start, @shuffle, @partition, @settings, @play]
      @method = new Property @, 'yazkqk', null
      @method.encode = (page) -> if page? then page.name else ''
      @method.decode = (name) => @getPage name
      @method.validate = (page) => page in [@shuffle, @partition, null]

      # The current page.
      @page = null

      # The previous page.
      @prev = null

      $('.sheet > span.prev > button, #play > span.prev > button').click =>
        @page.goPrev()

      $('.sheet > span.next > button').click =>
        @page.goNext()

    run: ->
      for property in @propertyAr
        property.load()
      for page in @pageAr
        page.brain = @
        page.ready = true

      @page = @method.get() ? @start
      @page.open()
      setInterval (=> @save()), config.saveInterval
      $(document.body).addClass 'visible'

      $(window).on 'beforeunload', =>
        @save()
        undefined

    save: ->
      for page in @pageAr
        for input in page.inputAr
          input.save()
      for property in @propertyAr
        property.save()

    getPage: (name) ->
      for page in @pageAr
        return page if page.name == name
      null
