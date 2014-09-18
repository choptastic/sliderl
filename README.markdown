# Sliderl

A simple markdown-based slideshow server using the [Nitrogen Web
Framework](http://nitrogenproject.com) and [reveal.js](http://revealjs.com).

## Demo

See a live demo at: http://slides.sigma-star.com

## Set up

  1. Install [Erlang](http://erlang.org/download)
  2. Clone sliderl: `git clone git://github.com/choptastic/sliderl`
  3. Change into the sliderl directory: `cd sliderl`
  4. Run `make`

## To view slideshows

  1. Put any slideshows into the `slideshows` directory
  2. Run `make run`
  3. Open your browser to http://127.0.0.1:8000

## Slideshows

* Slideshows are expected to be in Markdown
* Slides are separated by a single line containing three dashes (`---`) followed by a newline
* Fragmented slides can be made by appending `[frag=N]` where `N` is the fragment index. For example:
  ```markdown
    * this will be shown first [frag=1]
    * this will be shown next [frag=2]
    * this will be show at the end [frag=3]
  ```

## About

Copyight (c) 2013-2014, [Jesse Gumm](http://sigma-star.com/page/jesse)
([@jessegumm](http://twitter.com/jessegumm))

## License

Released under the MIT License
