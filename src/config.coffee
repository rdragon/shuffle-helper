define ->
  saveInterval: 10000
  max:
    cards: 9999
    cols: 18 # '1.mp3', ..., '18.mp3'
    rows: 6   # null, 'a.mp3', ..., 'e.mp3'
    time: 10000000
    int: Number.MAX_SAFE_INTEGER
    batchSize: 20
  ini:
    cards: 52
    stages: 3
    pileSizes: '5, 5, 5, 5'
    pile: 5
    batchSize: 3
    combineThreshold: 5
    startDelay: 1000
    cardDelay: 800
    sound:
      delay: 500
      loadDelay: 0
  msg:
    starting: "Starting..."
    nextStage: "Next stage"
  buttonClickedTime: 500
