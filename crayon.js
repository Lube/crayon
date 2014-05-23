// Generated by CoffeeScript 1.7.1
(function() {
  "use strict";
  var chalk, codes, hasColor, i, j, k, makeStyleFunc, pkg, stripAnsi, styleFuncs, _, __doc__;

  __doc__ = "An implementation of `chalk` with better performance characteristics\n";

  chalk = require('chalk');

  hasColor = require('has-color');

  stripAnsi = require('strip-ansi');

  codes = {
    reset: [0, 0],
    bold: [1, 22],
    italic: [3, 23],
    underline: [4, 24],
    inverse: [7, 27],
    strikethrough: [9, 29],
    black: [30, 39],
    red: [31, 39],
    green: [32, 39],
    yellow: [33, 39],
    blue: [34, 39],
    magenta: [35, 39],
    cyan: [36, 39],
    white: [37, 39],
    gray: [90, 39],
    bgBlack: [40, 49],
    bgRed: [41, 49],
    bgGreen: [42, 49],
    bgYellow: [43, 49],
    bgBlue: [44, 49],
    bgMagenta: [45, 49],
    bgCyan: [46, 49],
    bgWhite: [47, 49]
  };

  makeStyleFunc = function(styleNames) {
    "Creates and returns a function that applies a series of styles to a string (or\nlist of string) argument(s)";
    return function(s0, s1, s2) {
      var begin, end, s, sn, _i, _len, _ref;
      "Applies the style " + (styleNames.join('-')) + " to its (String) arguments";
      switch (arguments.length) {
        case 0:
          return '';
        case 1:
          s = s0;
          break;
        case 2:
          s = s0 + ' ' + s1;
          break;
        case 3:
          s = s0 + ' ' + s1 + ' ' + s2;
          break;
        default:
          s = [].slice.call(arguments).join(' ');
      }
      if (module.exports.enabled && s) {
        for (_i = 0, _len = styleNames.length; _i < _len; _i++) {
          sn = styleNames[_i];
          _ref = codes[sn], begin = _ref[0], end = _ref[1];
          s = '\u001b[' + begin + 'm' + s + '\u001b[' + end + 'm';
        }
      }
      return s;
    };
  };

  styleFuncs = {};

  for (i in codes) {
    _ = codes[i];
    styleFuncs[i] = makeStyleFunc([i]);
    for (j in codes) {
      _ = codes[j];
      styleFuncs[i][j] = makeStyleFunc([i, j]);
      for (k in codes) {
        _ = codes[k];
        styleFuncs[i][j][k] = chalk[i][j][k];
      }
    }
  }

  module.exports = styleFuncs;

  module.exports.supportsColor = hasColor;

  module.exports.stripColor = stripAnsi;

  if (module.exports.enabled == null) {
    module.exports.enabled = hasColor;
  }

  module.exports.__doc__ = require('fs').readFileSync(__dirname + '/README.md');

  pkg = require('./package');

  module.exports.version = pkg.version;

}).call(this);