define ['helper'], (helper) ->
  class Property
    constructor: (parent, @id, @ini) ->
      @changed = false
      @val = null
      @validate = -> true
      @encode = -> @
      @decode = -> @
      parent.propertyAr.push @

    set: (val) ->
      val = @ini if not @validate val
      if @val != val
        @val = val
        @changed = true

    get: ->
      @val

    save: ->
      return if not @changed
      helper.setItem @id, @encode @val
      @changed = false

    load: ->
      text = helper.getItem @id
      @set @decode(text) ? @ini
