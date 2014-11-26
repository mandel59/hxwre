package hxwre;

import hxwre.ds.Semiring;

private enum WRe<C,S,F:Semiring<S>> {
    Adv;
    Eps(f : C -> S);
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

    public function new(s : F) {
        this.s = s;
        this.adv = new WReg(s.zero, s.zero, Adv);
    }

    public var adv(default, null) : WReg<C,S,F>;

    function advM(m : S) : WReg<C,S,F> {
        return new WReg(s.zero, m, Adv);
    }

    public function eps(f : C -> S) : WReg<C,S,F> {
        return new WReg(s.zero, s.zero, Eps(f));
    }

    public function epsC(f : C -> S, c : C) : WReg<C,S,F> {
        return new WReg(f(c), s.zero, Eps(f));
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
            case Adv: advM(m);
            case Eps(f): epsC(f, c);
            case Alt(p, q):
                alt(shift(c, m, p), shift(c, m, q));
            case And(p, q):
                and(shift(c, m, p), shift(c, m, q));
            case Seq(p, q):
                seq(shift(c, m, p),
                    shift(c, s.plus(s.times(m, p.empty), p.final), q));
            case Rep(r):
                rep(shift(c, s.plus(r.final, m), r));
        };
    }

    public function match(r : WReg<C,S,F>, cs : Iterator<C>) : S {
        var c = cs.next();
        while (true) {
            r = shift(c, s.one, r);
            if (!cs.hasNext())
                break;
            c = cs.next();
        }
        return r.final;
    }
}
