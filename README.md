# Shuffle Helper
A web application that helps you shuffle a deck of cards of any size. The provided shuffle method is not very fast, but the resulting deck will be shuffled thoroughly. The [Mersenne Twister](https://en.wikipedia.org/wiki/Mersenne_Twister) is used as pseudorandom number generator.

## Installation
Run `npm install`. This command installs all dependencies and compiles the coffeescript files in `src/` into javascript files in `js/`. It also converts the markdown files in `docs/` to html files in `_docs/`. 

After installation you can use `npm start` to start a static HTTP server. Browse to http://localhost:9080 to see the application.

## Development
Use `npm run watch` to automatically compile coffeescript files into javascript files when a file change is detected. Alternatively, run `npm run build` to compile all coffeescript files into javascript files once.

Use `npm run docs` to convert the markdown files in `docs/` to html files in `_docs/`. 

## Shuffle instructions

The shuffle requires multiple stages. Each stage starts with a single pile containing all the cards. This initial pile is then spread over multiple other piles according to the pile numbers that are spoken. For each number that is spoken you place the current topmost card of the initial pile on top of the pile that corresponds to the given number.

After all the cards have been dealt out and the initial pile is empty, you combine the separate piles into a single pile again. This is done by stacking the piles on top of each other, with the first pile on the bottom and the last pile on top. The resulting pile will be the initial pile for the next stage, or the final shuffled deck in case of the last stage.

It's important to combine these piles correctly, otherwise the shuffle doesn't work as intended (however, in the last stage it doesn't really matter how you combine the cards).
