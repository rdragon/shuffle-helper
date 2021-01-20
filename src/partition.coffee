define ['jquery', 'config', 'helper', 'input', 'shuffler', 'page'], ($, config, helper, Input, Shuffler, Page) ->
  class Partition extends Page
    constructor: ->
      super 'partition'
      @input =
        nCards: new Input @, 'n9dccb', config.ini.cards, 2, config.max.cards
        pileSizes: new Input @, 'xdjalt', config.ini.pileSizes, 1, config.max.cards
        seed: new Input @, 'ztntec', 0, 0, config.max.int
      @span =
        nCardsLeft: $ '#aosz8w'
      @toggleRemaining = $ '.toggle-remaining'
      @button =
        duplicatePile: $ '#u8ljwm'
        reset: $ '#ful3gy'
      @shuffler = new Shuffler()

      # An array that contains for each stage an array that contains for each card the target pile number.
      @stages = null

      @button.duplicatePile.click =>
        pileSizes = @input.pileSizes.get()
        nCardsLeft = @nCardsLeft()
        unless pileSizes? && nCardsLeft? && nCardsLeft > 0
          @input.pileSizes.obj.focus()
          return
        pileSizes.push Math.min nCardsLeft, helper.last pileSizes
        @input.pileSizes.set pileSizes.join ', '

      @button.reset.click =>
        pileSizes = @input.pileSizes.get()
        if pileSizes?
          @input.pileSizes.set if pileSizes.length == 1 then '' else pileSizes[0].toString()
        @input.pileSizes.obj.focus()

    onOpen: ->
      @prev = @brain.start
      @next = @brain.settings
      @brain.method.set @

    onUpdate: ->
      @input.pileSizes.setMaxSum @nCards()
      nCardsLeft = @nCardsLeft()
      @span.nCardsLeft.text if nCardsLeft? then nCardsLeft else 0
      if @input.seed.get() == 0
        @input.seed.obj.addClass 'inactive'
      else
        @input.seed.obj.removeClass 'inactive'
    
    pileSizes: -> @input.pileSizes.get()

    # Returns the pile sizes filled in by the user plus a final pile containing the remaining cards (if any).
    getAllPileSizes: ->
      pileSizes = @pileSizes()
      return null unless pileSizes?
      nCardsLeft = @nCardsLeft()
      if nCardsLeft? then pileSizes.concat [nCardsLeft] else pileSizes

    nCards: -> @input.nCards.get()

    nCardsLeft: ->
      cards = @nCards()
      pileSizes = @pileSizes()
      return null unless cards? && pileSizes?
      nCardsLeft = cards - helper.sum pileSizes
      if nCardsLeft > 0 then nCardsLeft else null

    onClose: ->
      stage = []
      pileNumber = 0
      pileSizes = @getAllPileSizes()
      return unless pileSizes?
      for pileSize in pileSizes
        pileNumber++
        stage.push pileNumber for [1..pileSize] by 1
      stage = @shuffler.permute stage, @input.seed.get()
      @stages = [stage]
      
      

