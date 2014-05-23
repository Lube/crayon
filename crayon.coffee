"use strict"

__doc__ = """
An implementation of `chalk` with better performance characteristics

"""

chalk = require 'chalk'
hasColor = require 'has-color'
stripAnsi = require 'strip-ansi'

codes =
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


makeStyleFunc = (styleNames) ->
  """Creates and returns a function that applies a series of styles to a string (or
      list of string) argument(s)"""

  (s0, s1, s2) ->
    """Applies the style #{ styleNames.join '-' } to its (String) arguments"""

    switch arguments.length
      when 0 then return ''
      when 1 then s = s0
      when 2 then s = s0 + ' ' + s1
      when 3 then s = s0 + ' ' + s1 + ' ' + s2
      else s = [].slice.call(arguments).join ' '

    if module.exports.enabled and s
      for sn in styleNames
        [begin, end] = codes[sn]
        s = '\u001b[' + begin + 'm' + s + '\u001b[' + end + 'm'

    s

styleFuncs = {}

for i, _ of codes
  styleFuncs[i] = makeStyleFunc [i]
  for j, _ of codes
    styleFuncs[i][j] = makeStyleFunc [i, j]
    for k, _ of codes
      styleFuncs[i][j][k] = chalk[i][j][k]

module.exports = styleFuncs

module.exports.supportsColor = hasColor
module.exports.stripColor = stripAnsi

unless module.exports.enabled?
  module.exports.enabled = hasColor

module.exports.__doc__ = require('fs').readFileSync __dirname + '/README.md'

pkg = require './package'
module.exports.version = pkg.version
