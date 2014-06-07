package hxwre;

import hxwre.ds.Semiring;

private enum WRe<C,S,F:Semiring<S>> {
    Nil;
    Eps;
    Sym(f : C -> S);
    Alt(p : WReg<C,S,F>, q : WReg<C,S,F>);
    And(p : WReg<C,S,F>, q : WReg<C,S,F>);
    Seq(p : WReg<C,S,F>, q : WReg<C,S,F>);
    Rep(r : WReg<C,S,F>);
}

private class WReg<C,S,F:Semiring<S>> {
    public var empty : S;
    public var final : S;
    public var reg : WRe<C,S,F>;

    public function new(e, f, r) {
        this.empty = e;
        this.final = f;
        this.reg = r;
    }
}

class WRegExp<C,S,F:Semiring<S>> {
    var s : F;

    var nil_s : WReg<C,S,F>;
    var eps_s : WReg<C,S,F>;

    public function new(s : F) {
        this.s = s;
        this.nil_s = new WReg(s.zero, s.zero, Nil);
        this.eps_s = new WReg(s.one, s.zero, Eps);
    }

    public var nil(get, never) : WReg<C,S,F>;
    public function get_nil() return nil_s;

    public var eps(get, never) : WReg<C,S,F>;
    public function get_eps() return eps_s;

    public function sym(f : C -> S) : WReg<C,S,F> {
        return new WReg(s.zero, s.zero, Sym(f));
    }

    function symFinal(f : C -> S, m : S) : WReg<C,S,F> {
        return new WReg(s.zero, m, Sym(f));
    }

    public function alt(p : WReg<C,S,F>, q : WReg<C,S,F>) : WReg<C,S,F> {
        return new WReg(
            s.plus(p.empty, q.empty), s.plus(p.final, q.final), Alt(p, q));
    }

    public function and(p : WReg<C,S,F>, q : WReg<C,S,F>) : WReg<C,S,F> {
        return new WReg(
            s.times(p.empty, q.empty), s.times(p.final, q.final), And(p, q));
    }

    public function seq(p : WReg<C,S,F>, q : WReg<C,S,F>) : WReg<C,S,F> {
        return new WReg(
            s.times(p.empty, q.empty),
            s.plus(s.times(p.final, q.empty), q.final), Seq(p, q));
    }

    public function rep(r : WReg<C,S,F>) : WReg<C,S,F> {
        return new WReg(s.one, r.final, Rep(r));
    }

    public function shift(c : C, m : S, re : WReg<C,S,F>) : WReg<C,S,F> {
        return switch (re.reg) {
            case Nil: nil;
            case Eps: eps;
            case Sym(f): symFinal(f, s.times(m, f(c)));
            case Alt(p, q):
                alt(shift(c, m, p), shift(c, m, q));
            case And(p, q):
                and(shift(c, m, p), shift(c, m, q));
            case Seq(p, q):
                seq(shift(c, m, p),
                    shift(c, s.plus(s.times(m, p.empty), p.final), q));
            case Rep(r):
                rep(shift(c, s.plus(m, r.final), r));
        };
    }

    public function match(r : WReg<C,S,F>, cs : Iterator<C>) : S {
        if (!cs.hasNext()) return r.empty;
        var r = shift(cs.next(), s.one, r);
        for (c in cs) {
            r = shift(c, s.zero, r);
        }
        return r.final;
    }
}
