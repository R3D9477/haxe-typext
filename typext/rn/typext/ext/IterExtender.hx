package rn.typext.ext;

class IterExtender<T> {
	public static function array<T> (iter:Iterator<T>) : Array<T> return Lambda.array({ iterator : function() { return iter; } });
}
