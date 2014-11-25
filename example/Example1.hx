package example;

import hxwre.ds.SemiringBool;
import hxwre.WRegExp;
using hxwre.WRegExpMacro;

class Example1 {

    public static function iterator(s : String) {
        var i = 0;
        return {
            hasNext: function() return i < s.length,
            next: function() return s.charCodeAt(i++),
        };
    }

    public static function main() {
        var w = new WRegExp(SemiringBool);

        var rep = w.rep;
        var lit = function(c) return w.sym(function(x) return x == c);
        var a = lit('a'.code);
        var b = lit('b'.code);

        var even = w.build( rep( rep(b) >> a >> rep(b) >> a ) >> rep(b) );
        trace(w.match(even, iterator("aababbababb")));
        trace(w.match(even, iterator("aabbaabbaba")));

    }

}
