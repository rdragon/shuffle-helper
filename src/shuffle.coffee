define ['jquery', 'config', 'helper', 'input', 'shuffler', 'page'], ($, config, helper, Input, Shuffler, Page) ->
  class Shuffle extends Page
    constructor: ->
      super 'shuffle'
      @input =
        nCards: new Input @, 'w9vq0a', config.ini.cards, 2, config.max.cards
        nStages: new Input @, 'piyloo', config.ini.stages, 1, config.max.cards
        seed: new Input @, 'utmgre', 0, 0, config.max.int
      @pileSizes = $ '#eyqifv'
      @sheet = $ '.sheet.shuffle'
      @shuffler = new Shuffler()

      # The permutation of the cards.
      # This value is equal to a permutation of [1..nCards].
      @perm = null

      # An array that contains for each stage an array that contains for each card the target pile number.
      @stages = null

    onOpen: ->
      @brain.method.set @
      @prev = @brain.start
      @next = @brain.settings

    onUpdate: ->
      nCards = @nCards()
      return if not nCards?
      @input.nStages.setMin @shuffler.computeMinStages nCards
      @input.nStages.setMax @shuffler.computeMaxStages nCards
      nStages = @nStages()
      @pileSizes.text @shuffler.computePileSizes(nCards, nStages).join ', ' if nStages?
      if @input.seed.get() == 0
        @input.seed.obj.addClass 'inactive'
      else
        @input.seed.obj.removeClass 'inactive'
    
    nCards: -> @input.nCards.get()

    nStages: -> @input.nStages.get()
    
    onClose: ->
      @perm = @shuffler.permute [1..@nCards()], @input.seed.get()
      @stages = @shuffler.getStages @nStages(), @perm
