package hxwre.ds;

typedef Semiring<T> = {
    var zero(default, null) : T;
    var one(default, null) : T;

    function plus(a : T, b : T) : T;
    function times(a : T, b : T) : T;
}
