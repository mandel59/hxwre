package hxwre;

import haxe.macro.Expr;
import hxwre.ds.Semiring;

class WRegExpMacro {
    static function buildwregex<C,S,F:Semiring<S>>
            (r : ExprOf<WRegExp<C,S,F>>, e : Expr) : Expr {
        return switch (e.expr) {
            case EBinop(op, e1, e2):
                var e1 = buildwregex(r, e1);
                var e2 = buildwregex(r, e2);
                switch (op) {
                    case OpOr: macro $r.alt($e1, $e2);
                    case OpAnd: macro $r.and($e1, $e2);
                    case OpShr: macro $r.seq($e1, $e2);
                    case _: e;
                }
            case ECall(e, params):
                var e = buildwregex(r, e);
                var params = [for (e in params) buildwregex(r, e)];
                macro $e($a{params});
            case _ : e;
        }
    }

    macro public static function build<C,S,F:Semiring<S>>
            (r : ExprOf<WRegExp<C,S,F>>, e : Expr) : Expr {
        return buildwregex(r, e);
    }
}
