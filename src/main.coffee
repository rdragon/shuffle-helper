window.console ?= {}
for x in ['log', 'warn', 'error', 'assert']
  window.console[x] = (->) if not console[x]?

requirejs.config
  baseUrl: 'js'
  paths:
    howler: '../lib/howler-2.2.1.core.min'
    jquery: '../lib/jquery-3.5.1.slim.min'
    'mersenne-twister': '../lib/mersenne-twister.min'

requirejs ['jquery', 'brain'], ($, Brain) -> $ ->
  brain = new Brain()
  brain.run()
