define ['howler', 'config', 'helper', 'page'], (howler, config, helper, Page) ->
  class Play extends Page
    constructor: ->
      super 'play'
      @button = $ '#play > span.next > button'
      @sounds = ("#{i}" for i in [1..config.max.cols]).concat ['times', 'pile', 'silence', 'a', 'b', 'c', 'd', 'e']
      @curStage = null
      @stages = null
      @settings = null
      @nCards = null

      # Determines the duration of a batch.
      # The next batch loads after the card delay multiplied by the number of cards in the batch.
      @cardDelay = null

      # An object that contains all howler objects for playing sounds.
      @howl = null
      
      # These two variables are used to clear running setTimeout timeouts.
      @timeout1 = null
      @timeout2 = null

      # The zero-based index of the first card of the currently shown batch.
      @at = null

      # The zero-based index of the first card of the next batch.
      @nextAt = null

      # A value like 'us-sali' or 'nl-ruben'.
      @voice = null
      
      # The number of columns.
      @nCols = null

      # The number of rows.
      @nRows = null

      @button.click =>
        @clearTimeouts()
        if @button.text() == config.msg.nextStage
          @beginPlay()
        else
          @tick()

    clearTimeouts: ->
      clearTimeout @timeout1 if @timeout1?
      clearTimeout @timeout2 if @timeout2?
    
    loadVoice: ->
      oldVoice = @voice
      @voice = @settings.voice.get()
      return if oldVoice == @voice
      @howl = {}
      @howl[sound] = new howler.Howl(src: "sounds/#{@voice}/#{sound}.mp3") for sound in @sounds

    onOpen: ->
      @settings = @brain.settings
      @loadVoice() if @settings.sound.get()
      @curStage = @settings.curStage
      @stages = @settings.stages
      @at = @settings.table.get()
      @nextAt = @at
      @nCards = @settings.nCards
      nPiles = @settings.nPiles
      @nCols = @settings.nCols.get()
      @nRows = (nPiles + @nCols - 1) // @nCols
      @cardDelay = @settings.getCardDelay()
      @beginPlay()

      # The first sound sometimes takes a bit longer to load, which can cause it to overlap
      # with the second sound.
      # This line seems to prevent that problem.
      @howl['silence'].play() if @howl

    beginPlay: ->
      @button.text config.msg.starting
      @timeout1 = setTimeout (=> @tick()), config.ini.startDelay

    onEndStage: () ->
      @at = 0
      @nextAt = 0
      @curStage++
      if @curStage > @stages.length
        @curStage = 1
        @goPrev()
      else
        @button.text config.msg.nextStage
    
    stopSounds: ->
      @howl[sound].stop() for sound in @sounds if @howl

    tick: ->
      @clearTimeouts()
      @at = @nextAt
      return @onEndStage() if @at >= @nCards
      stage = @stages[@curStage - 1]
      textAr = []
      size = 0
      time = 0
      at = @at
      @soundAr = []
      while at < @nCards
        [text, soundAr, groupSize, groupTime, newAt] = @getGroup stage, at
        break if size > 0 && groupSize + size > @settings.batchSize.get()
        size += groupSize
        time += groupTime
        @soundAr.push sound for sound in soundAr
        at = newAt
        textAr.push text
      @nextAt = at
      @button.text textAr.join ', '
      @timeout1 = setTimeout (=> @tick()), time
      @soundAr.reverse()
      @soundTick() if @settings.sound.get()

    soundTick: ->
      sound = @soundAr.pop()
      next = if @soundAr.length == 0 then null else helper.last @soundAr
      @howl[sound].play()
      return if not next?
      delay = @settings.getSoundDelay()
      @timeout2 = setTimeout (=> @soundTick()), delay

    getGroup: (stage, at) ->
      pile = stage[at]
      if pile <= @nCols
        newAt = at + 1
        count = 1
        while newAt < @nCards && stage[newAt] == pile && count < config.max.cols
          newAt++
          count++
        if count >= @settings.combineThreshold.get() && pile <= @nCols
          delay = @cardDelay * (2 + count / 2)
          word = if @voice.startsWith 'nl' then 'plek' else 'pile'
          ["#{word} #{pile} x #{count}", ['pile', pile, 'times', count], @settings.batchSize.get(), delay, newAt]
        else
          ["#{pile}", [pile], 1, @cardDelay, at + 1]
      else
        row = String.fromCharCode (((pile - 1) // @nCols) + 96)
        col = (pile - 1) %% @nCols + 1
        ["#{row}#{col}", [row, col], 1, @cardDelay, at + 1]

    onClose: ->
      @clearTimeouts()
      @settings.curStage = @curStage
      @settings.setTable @at
      @stopSounds()
