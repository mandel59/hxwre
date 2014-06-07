package hxwre.ds;

class SemiringBool {
    static var s = new SemiringBool();

    public static var singleton(get, never) : SemiringBool;
    static function get_singleton() return s;

    function new() {}

    public var zero(get, never) : Bool;
    function get_zero() return false;

    public var one(get, never) : Bool;
    inline function get_one() return true;

    public function plus(a : Bool, b : Bool) : Bool return a || b;
    public function times(a : Bool, b : Bool) : Bool return a && b;
}
