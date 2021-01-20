define ['helper'], (helper) ->
  class Input
    constructor: (@page, @id, @ini, min = null, max = null, step = null) ->
      @changed = false
      @obj = $ '#' + @id
      @type = @obj.attr 'type'
      @checkbox = @type == 'checkbox'
      @select = @obj.is 'select'
      @intAr = @type == 'text'
      @number = @type == 'number'
      @double = @number && @obj.hasClass 'double'
      @page.addInput @
      if @number
        console.assert min? && max?
        @obj.attr 'min', min
        @obj.attr 'max', max
        @obj.attr 'step', step if step?
      else
        @min = min
        @max = max
      @maxSum = null
      @load()

      if @number || @intAr
        @obj.on 'input', =>
          @changed = true
          @validate()
          @page.update()

      if @checkbox || @select
        @obj.on 'change', =>
          @changed = true
          @validate()
          @page.update()

    load: ->
      val = helper.getItem(@id)
      if @checkbox
        val = switch val
          when 'true' then true
          when 'false' then false
          else null
      @set val ? @ini

    reset: ->
      @set @ini

    set: (val) ->
      changed = false
      if @checkbox
        console.assert helper.bool val
        if val != @get()
          @obj.prop 'checked', val
          changed = true
      else
        console.assert helper.string val if @intAr
        console.assert helper.int(val) || helper.string val if @number
        text = val.toString()
        if @obj.val() != text
          @obj.val text
          changed = true
      if changed
        @changed = true
        @validate()
        @page.update() if @page.ready
    
    setMin: (min) ->
      if @number
        @obj.attr 'min', min
      else
        @min = min
      @validate()
    
    setMax: (max) ->
      if @number
        @obj.attr 'max', max
      else
        @max = max
      @validate()
    
    setMaxSum: (maxSum) ->
      @maxSum = maxSum
      @validate()

    validate: ->
      return if @checkbox
      if @get()?
        @obj.removeClass 'error'
      else
        @obj.addClass 'error'

    getMin: ->
      if @number then parseFloat @obj.prop 'min' else @min

    getMax: ->
      if @number then parseFloat @obj.prop 'max' else @max

    # Returns a valid value or null.
    get: ->
      if @intAr
        helper.getIntAr @obj.val(), @getMin(), @getMax(), @maxSum, 1
      else if @double
        helper.getDouble @obj.val(), @getMin(), @getMax()
      else if @number
        helper.getInt @obj.val(), @getMin(), @getMax()
      else if @checkbox
        @obj.prop 'checked'
      else if @select
        @obj.val()
      else
        null
    
    toString: ->
      value = @get()
      return null if not value?
      return value.join ', ' if @intAr
      "#{value}"

    save: ->
      return if not @changed
      text = @toString()
      return if not text?
      helper.setItem @id, text
      @changed = false
