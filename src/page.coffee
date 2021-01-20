define ['jquery', 'helper'], ($, helper) ->
  class Page
    constructor: (@name) ->
      console.assert helper.string @name
      @inputs = $ []
      @inputAr = []
      @ready = false
      @brain = null

      # The page to move to when the user clicks on a back button.
      @prev = null
      
      # The page to move to when the user clicks on a next page button.
      @next = null

    goNext: ->
      if @inputs.is '.error'
        @inputs.filter('.error').first().focus()
      else
        console.assert @next?
        @next.prev = @
        @next.open()

    goPrev: ->
      console.assert @prev?
      @prev.open()

    open: ->
      @brain.page.onClose() if @brain.page?
      $(document.body).addClass page.name for page in @brain.pageAr
      $(document.body).removeClass @name
      @brain.prevPage = @brain.page
      @brain.page = @
      @onOpen()
      @update()

    addInput: (input) ->
      @inputAr.push input
      @inputs = @inputs.add input.obj[0]

    update: -> @onUpdate()

    # Called after one of the inputs on the page is updated by the user.
    onUpdate: ->

    # Called just before a new page is opened.
    onClose: ->

    # Called just after a new page is shown.
    onOpen: ->
