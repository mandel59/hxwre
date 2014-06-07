package hxwre.ds;

typedef Semiring<T> = {
    var zero(get, never) : T;
    var one(get, never) : T;

    function plus(a : T, b : T) : T;
    function times(a : T, b : T) : T;
}
