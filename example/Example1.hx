package example;

import hxwre.ds.SemiringBool;
import hxwre.ds.SemiringCaptures;
import hxwre.WRegExp;
using hxwre.WRegExpMacro;

typedef W = { index : Int, char : Null<Int> }

class Example1 {

    public static function iterator(s : String) {
        var i = 0;
        return {
            hasNext: function() return i <= s.length,
            next: function() {
                var index = i;
                i++;
                return {
                    index : index,
                    char : if (index >= s.length) null else s.charCodeAt(index)
                };
            }
        };
    }

    public static function main() {
        var s = new SemiringCaptures(4);
        var w = new WRegExp(s);

        var rep = w.rep;
        var begin = w.eps(function(x : W) return if (x.index == 0) s.one else s.zero);
        var end = w.eps(function(x : W) return if (x.char == null) s.one else s.zero);
        var cap = function (n)
            return w.eps(function(x : W) return s.set(n, x.index));
        var lit = function (c)
            return w.seq(w.eps(function(x : W) return if (x.char == c) s.one else s.zero), w.adv);

        var a = lit('a'.code);
        var b = lit('b'.code);

        var even = w.build(
            begin
            >> cap(0)
            >> cap(2)
            >> rep( rep(b) >> a >> rep(b) >> a )
            >> cap(3)
            >> rep(b)
            >> cap(1)
            >> end
        );
        trace(w.match(even, iterator("aababbababbbb")));
        trace(w.match(even, iterator("aabbaabbababb")));

    }

}
