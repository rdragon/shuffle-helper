define ['helper', 'config', 'mersenne-twister'], (helper, config, MersenneTwister) ->
  class Shuffler
    getStages: (nStages, perm) ->
      nCards = perm.length
      nPiles = @computePiles nCards, nStages
      masks = (x - 1 for x in perm)
      for curStage in [nStages..1]
        swap = curStage %% 2 == 1
        ids = ((if swap then -x - 1 else x) %% nPiles + 1 for x in masks)
        masks = @runStage masks, ids, nPiles
        masks = (x // nPiles for x in masks)
        ids
    
    permute: (ar, seed) ->
      mt = new MersenneTwister (if seed? && seed > 0 then seed else null)
      n = ar.length
      for i in [0..(n - 2)] by 1
        j = i + Math.floor mt.random() * (n - i)
        [ar[i], ar[j]] = [ar[j], ar[i]] if j > i
      ar

    computeMinStages: (nCards) ->
      nStages = 1
      nStages++ while (@computePiles nCards, nStages) > config.max.cols * config.max.rows
      nStages
    
    computeMaxStages: (nCards) ->
      return 1 if nCards == 2
      nStages = 2
      nStages++ while (@computePiles nCards, nStages) > 2
      nStages
    
    runStage: (masks, ids, nPiles) ->
      piles = ([] for [0..nPiles])
      nCards = masks.length
      piles[ids[i]].push masks[i] for i in [0..nCards-1]
      pile.reverse() for pile in piles
      piles.reverse()
      helper.flatten piles
    
    # Returns the number of piles that are required to shuffle nCards cards in nStages stages.
    computePiles: (nCards, nStages) ->
      if nStages == 1
        return nCards
      nPiles = 2
      nPiles++ while nPiles ** nStages < nCards
      nPiles
    
    # Returns for each stage the number of required piles.
    computePileSizes: (nCards, nStages) ->
      nPiles = @computePiles nCards, nStages
      x = nPiles ** (nStages - 1)
      y = 2
      y++ while x * y < nCards
      (helper.replicate nStages - 1, nPiles).concat [y]
    