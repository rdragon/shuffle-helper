define ['jquery', 'config', 'input', 'page', 'helper'], ($, config, Input, Page, helper) ->
  class Settings extends Page
    constructor: ->
      super 'settings'
      @sheet = $ '.sheet.settings'
      @span =
        stage: $ '#j0u038'
        perm: $ '#ioizey'
        numbers: $ '#atcymk'
        curPiles: $ '#yfmmjf'
      @togglePerm = $ '.toggle-perm'
      @toggleNumbers = $ '.toggle-numbers'
      @togglePiles = $ '.toggle-piles'
      @button =
        nextStage: $ '#d30fy6'
        perm: $ '#qmysdh'
      @batchSize = new Input @, 'v0kry6', config.ini.batchSize, 1, config.max.batchSize
      @cardDelay = new Input @, 'm1gn5w', config.ini.cardDelay, 100, config.max.time, 100
      @combineThreshold = new Input @, 'yifprg', config.ini.combineThreshold, 1, config.max.cards
      @nCols = new Input @, 'wfdmam', config.max.cols, 1, config.max.cols
      @sound = new Input @, 'a50sjp', true
      @soundDelay = new Input @, 'pdk906', config.ini.sound.delay, 100, config.max.time, 100
      @voice = new Input @, 'yvhbow', 'us-sali'
      @table = new Input @, 'gm9vk8', 0, 0, config.max.cards
      @hand = new Input @, 'r1nvgh', 0, 0, config.max.cards
      @soundInputs = $ 'input.sound, select.sound'
      @soundLabels = $ 'label.sound'

      # The number of cards.
      @nCards = null

      # The number of stages.
      @nStages = null

      # The maximum number of piles in any stage.
      @nPiles = null

      # The current stage number (a value between 1 and nStages).
      @curStage = null

      # The permutation of the cards.
      # This value is equal to a permutation of [1..cards].
      @perm = null

      # An array that contains for each stage an array that contains for each card the target pile number.
      @stages = null

      @table.obj.on 'input', =>
        table = @table.get()
        @hand.set @nCards - table if table?

      @hand.obj.on 'input', =>
        hand = @hand.get()
        @table.set @nCards - hand if hand?
      
      @button.nextStage.click =>
        @curStage = (@curStage %% @nStages) + 1
        @setTable 0
        @update()
      
      @button.perm.click =>
        if @perm?
          @span.perm.text @perm.join ', '
          @span.numbers.text (x.join ', ' for x in @stages).join ', next stage, '
          @togglePerm.removeClass 'hidden'
        else
          @span.numbers.text @stages[0].join ', '
        @toggleNumbers.removeClass 'hidden'
        @button.perm.addClass 'hidden'

    onUpdate: ->
      if @sound.get()
        @soundLabels.removeClass 'disabled'
        @soundInputs.prop 'disabled', false
      else
        @soundLabels.addClass 'disabled'
        @soundInputs.prop 'disabled', true
      @span.stage.text "#{@curStage}/#{@nStages}" if @curStage?
      @updateCurPiles()
    
    updateCurPiles: ->
      curPiles = @getCurPiles()
      if curPiles?
        @togglePiles.removeClass 'hidden'
        @span.curPiles.text curPiles.join ', '
      else
        @togglePiles.addClass 'hidden'
    
    getCurPiles: ->
      table = @table.get()
      return null unless table? && table > 0 && @stages? && @curStage? && @curStage <= @stages.length
      stage = @stages[@curStage - 1]
      curPiles = helper.replicate @nPiles, 0
      curPiles[stage[i] - 1]++ for i in [0..table-1]
      curPiles

    setTable: (table) ->
      @table.set table
      @hand.set @nCards - table

    onOpen: ->
      @button.perm.removeClass 'hidden'
      @togglePerm.addClass 'hidden'
      @toggleNumbers.addClass 'hidden'
      @next = @brain.play
      return if @brain.prevPage != @brain.shuffle && @brain.prevPage != @brain.partition
      @perm = @brain.prevPage.perm
      @stages = @brain.prevPage.stages
      @nCards = @brain.prevPage.nCards()
      @nStages = @stages.length
      if @nStages == 1
        @sheet.addClass 'one'
      else
        @sheet.removeClass 'one'
      if @perm?
        @button.perm.text 'View permutation'
      else
        @button.perm.text 'View numbers'
      @table.setMax @nCards
      @hand.setMax @nCards
      @nPiles = Math.max ...helper.flatten @stages
      @nCols.setMin ((@nPiles + config.max.rows - 1) // config.max.rows)
      @curStage = 1
      @setTable 0
    
    getSoundDelay: -> @soundDelay.get()

    getCardDelay: -> @cardDelay.get()
