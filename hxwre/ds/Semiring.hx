package hxwre.ds;

typedef Semiring<T> = {
    public var zero(get, never) : T;
    public var one(get, never) : T;

    public function plus(a : T, b : T) : T;
    public function times(a : T, b : T) : T;
}
