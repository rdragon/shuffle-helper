define ['jquery'], ($) ->
  noStorage = true
  try
    x = '__test__'
    localStorage.setItem x, x
    localStorage.removeItem x
    noStorage = false

  helper =
    getInt: (text, min, max) ->
      console.assert min? && max? && helper.string(text) && helper.int(min) && helper.int(max)
      text = text.trim()
      return null if not /^(0|-?[1-9][0-9]*)$/.test text
      n = parseInt text
      if min <= n <= max then n else null

    getIntAr: (text, min, max, maxSum, minLength) ->
      console.assert min? && max? && helper.string(text) && helper.int(min) && helper.int(max)
      ar = []
      sum = 0
      textAr = (val.trim() for val in text.split /[, ]+/)
      for text, i in textAr
        if i < textAr.length - 1 || text.length > 0
          n = helper.getInt text, min, max
          return null if not n?
          ar.push n
          sum += n
          return null if maxSum? && sum > maxSum
      if minLength? && ar.length < minLength then null else ar

    getDouble: (text, min, max) ->
      console.assert min? && max? && helper.string(text) && helper.num(min) && helper.num(max)
      text = text.trim()
      return null if not /^(0|-?[1-9][0-9]*)((\.|,)[0-9]*)?$/.test text
      x = parseFloat text
      if min <= x <= max then x else null

    getItem: (key) ->
      console.assert helper.string key
      if noStorage then null else localStorage.getItem(key)

    setItem: (key, val) ->
      console.assert helper.string(key) && helper.string val
      return if noStorage
      try
        localStorage.setItem key, val
      catch e
        console.error e

    sum: (xs) ->
      console.assert $.isArray xs
      xs.reduce ((x, y) -> x + y), 0

    maximum: (xs) ->
      console.assert $.isArray xs
      Math.max.apply [], xs

    product: (xs) ->
      console.assert $.isArray xs
      xs.reduce ((x, y) -> x * y), 1

    string: (val) ->
      typeof val == 'string'

    num: (val) ->
      typeof val == 'number'

    int: (val) ->
      helper.num(val) && Math.round val == val

    intAr: (ar) ->
      $.isArray(ar) && ar.every((val) -> helper.int val)

    bool: (val) ->
      typeof val == 'boolean'

    flatten: (ar) ->
      [].concat.apply [], ar

    last: (ar) ->
      ar[ar.length - 1]

    group: (xs) ->
      return [] if xs.length == 0
      ys = null
      col = []
      for x in xs
        if ys? && ys[0] == x
          ys.push x
        else
          ys = [x]
          col.push ys
      col

    sortNumbers: (ar) ->
      ar1 = ar.slice()
      ar1.sort((x, y) -> x - y)
      ar1
    
    replicate: (n, x) -> (x for [1..n] by 1)
