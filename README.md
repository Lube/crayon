crayon
======

A faster version of chalk

This should do the exact same thing as `chalk` with the same API.

It should be a bit faster because it doesn't create dynamic getters as you go.
It also doesn't do an `arguments.slice` and `join` if it doesn't need to, in the common
case where you are just calling the style function on a single string, or 2 or 3 strings.

If you chain styles more than 2 levels deep, it will start using `chalk`'s dynamic getters, and
if you give more then 3 strings as arguments, it will start using `arguments.slice`.
