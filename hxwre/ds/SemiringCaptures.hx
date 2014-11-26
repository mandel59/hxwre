package hxwre.ds;

typedef T = Null<Array<Null<Int>>>

class SemiringCaptures {
	var length : Int;

	public function new(len : Int) {
		this.length = len;
		this.one = [for (i in 0 ... length) null];
	}

	public var zero(default, null) : T = null;
	public var one(default, null) : T;

	public inline function plus(a : T, b : T) : T {
		return if (a != null) a else b;
	}

	public inline function times(a : T, b : T) : T {
		return if (a == null || b == null) null
			else [for (i in 0 ... length) {
				var x = a[i];
				if (x != null) x else b[i];
			}];
	}

	public inline function set(n : Int, index : Int) {
		return [for (i in 0 ... length) if (i == n) index else null];
	}
}
