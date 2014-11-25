package hxwre.ds;

class SemiringBool {
    public static var zero(default, null) : Bool = false;
    public static var one(default, null) : Bool = true;

    public static inline function plus(a : Bool, b : Bool) : Bool return a || b;
    public static inline function times(a : Bool, b : Bool) : Bool return a && b;
}
