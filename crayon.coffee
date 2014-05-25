"use strict"

__doc__ = """
An implementation of `chalk` with better performance characteristics, 256 color support, a few other features, and built-in logging.

"""

util = require 'util'

hasColor = require 'has-color'
stripAnsi = require 'strip-ansi'

ansi256css = require './ansi256css'
cssToAnsi = require './css-to-ansi'

logLevels = ['log', 'info', 'debug', 'warn', 'error']

basics =
  reset: [0, 0]

  bold: [1, 22]
  italic: [3, 23]
  underline: [4, 24]
  inverse: [7, 27]
  strikethrough: [9, 29]

  black: [30, 39]
  red: [31, 39]
  green: [32, 39]
  yellow: [33, 39]
  blue: [34, 39]
  magenta: [35, 39]
  cyan: [36, 39]
  white: [37, 39]
  gray: [90, 39]

  bgBlack: [40, 49]
  bgRed: [41, 49]
  bgGreen: [42, 49]
  bgYellow: [43, 49]
  bgBlue: [44, 49]
  bgMagenta: [45, 49]
  bgCyan: [46, 49]
  bgWhite: [47, 49]

basics.grey = basics.gray

codes = {}
for styleName, [begin, end] of basics
  codes[styleName] = ['\u001b[' + begin + 'm', '\u001b[' + end + 'm']

for color, code of cssToAnsi
  if basics[color]?
    color = color + '_'
  codes[color] = ['\u001b[38;5;' + code + 'm', '\u001b[39m']
  codes['bg' + color[0].toUpperCase() + color[1...].toLowerCase()] = ['\u001b[48;5;' + code + 'm', '\u001b[49m']

addColorFuncs = (obj, prevStyles) ->
  """Adds functions like `.red` to an object"""

  for name, style of codes

    do (name, style) ->
      Object.defineProperty obj, name,
        enumerable: true
        configurable: true
        get: ->
          newStyles = [codes[name]].concat prevStyles
          f = makeStyleFunc newStyles
          f.__doc__ = """Applies the style '#{ name }' to the crayon"""
          delete obj[name]
          obj[name] = f

  for [name, newStyleFunc] in [
    ['foreground', (x) -> [foregroundCode getColorNumber x]]
    ['background', (x) -> [backgroundCode getColorNumber x]]
    ['fgbg', (fg, bg) ->  [foregroundCode(getColorNumber fg), backgroundCode(getColorNumber bg)]]
    ['color', general]
  ]
    do (name, newStyleFunc) ->
      obj[name] = (desc...) ->
        makeStyleFunc newStyleFunc(desc...).concat prevStyles

  obj.fg = obj.foreground
  obj.bg = obj.background
  obj._ = obj.color

  obj.color.__doc__ = """Applies any styles and colors you pass in; accepts multiple arguments"""
  obj.foreground.__doc__ = """Sets the foreground color for the crayon"""
  obj.background.__doc__ = """Sets the background color for the crayon"""
  obj.fgbg.__doc__ = """Takes two arguments -- a foreground color and a background color -- and applies those styles to the crayon"""


makeStyleFunc = (styles) ->
  """Returns a function that applies a list of styles

    Styles are encoded using an Array with their literal escape sequences: [<begin>, <end>]"""

  f = (args...) ->

    s = util.format args...
    if crayon.enabled
      for [begin, end] in styles
        s = begin + s + end
    s

  addColorFuncs f, styles

  for level in logLevels
    do (level) ->
      f[level] = (args...) ->
        crayon.logger[level] f util.format args...

  f

getColorNumber = (desc) ->
  num = ansi256css desc
  unless num?
    throw new Error "Don't understand the color '#{ desc }'"
  num

foregroundCode = (number) -> ['\u001b[38;5;' + number + 'm', '\u001b[39m']
backgroundCode = (number) -> ['\u001b[48;5;' + number + 'm', '\u001b[49m']

ansiStyle = (desc) ->
  re = /^(bg|background):?/i
  unless re.test desc
    foregroundCode getColorNumber desc
  else
    backgroundCode getColorNumber desc.replace(re, '')

splitFlatten = (list) -> [].concat.apply [], (x.split /\s+/ for x in list)

general = (styles...) ->  (codes[x] ? ansiStyle x for x in splitFlatten(styles).reverse())

module.exports = crayon = (styles...) -> makeStyleFunc general styles...

addColorFuncs crayon, []

crayon.supportsColor = hasColor
crayon.stripColor = stripAnsi

unless crayon.enabled?
  crayon.enabled = hasColor

unless crayon.logger?
  crayon.logger = console

# Add the logging functions from the logger as properties on here so that
# if the logger changes, you get different values for these
for level in logLevels
  do (level) ->
    Object.defineProperty crayon, level,
      enumerable: true
      configurable: true
      get: ->
        crayon.logger[level]

# For rough compatibility with the API of jharding's crayon module
# that is currently "crayon" in npm. (https://github.com/jharding/crayon)
Object.defineProperty crayon, 'success',
  enumerable: true
  configurable: true
  get: ->
    crayon.logger?.success ? (args...) ->
      crayon.green.log args...

crayon.__doc__ = require('fs').readFileSync __dirname + '/README.md', 'utf8'
pkg = require './package'
crayon.version = pkg.version


