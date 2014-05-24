crayon
=====

A faster version of [chalk](https://github.com/sindresorhus/chalk) -- a module for adding ANSI terminal colors to your text.

This module does the exact same thing as `chalk` with the same API except
that `crayon` is much faster for most use cases and also has 256 color 
support.

Crayon is faster thank chalk because it doesn't create dynamic getters as you 
go in the common cases where you are only making a simple call like `.red` or 
chaining one level deep like `.red.bgGreen`.

It also doesn't do an `arguments.slice` and `join` if it doesn't need to, 
in the common case where you are just calling the style function on a 
single string, or 2 or 3 strings.

If you chain styles more than 2 levels deep, it will start using `chalk`'s 
dynamic getters, and if you give more then 3 strings as arguments, it
will start using `arguments.slice`.


## Usage

Simple usage is the same as `chalk`.

Chalk comes with an easy to use composable API where you just chain and nest the styles you want. `crayon` supports this API as well.

```js
var crayon = require('crayon');

// style a string
console.log(  crayon.blue('Hello world!')  );

// combine styled and normal strings
console.log(  crayon.blue('Hello'), 'World' + crayon.red('!')  );

// compose multiple styles using the chainable API
console.log(  crayon.blue.bgRed.bold('Hello world!')  );

// nest styles
console.log(  crayon.red('Hello', crayon.underline.bgBlue('world') + '!')  );

// pass in multiple arguments
console.log(  crayon.blue('Hello', 'World!', 'Foo', 'bar', 'biz', 'baz')  );
```

You can also use the 256 color ANSI palette this module. For now, the 
interface is slightly different than the way you access the normal colors. 

```js
var crayon = require('crayon');

// Set the foreground color
console.log(crayon('darkred')("The foreground color is set to dark red here"));

// Set the foreground and background colors
console.log(crayon('goldenrod', 'dodgerblue')("yellow on blue background"));

// Mix in other chalk styles as well
console.log(crayon('goldenrod', 'dodgerblue', 'inverse', 'underline')("inverted and underlined"));
```

You can pass in any ANSI 256 color code, CSS color name, or CSS hex description of a color. The first argument sets the foreground color; the second argument 
is optional and sets the background color. All other arguments are styles you
could give to chalk that will be also applied, ex. `'underline'` or `'inverse'`.


