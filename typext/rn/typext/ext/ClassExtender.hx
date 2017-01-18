package rn.typext.ext;

class ClassExtender {
	public static function is (cls:Class<Dynamic>, destCls:Class<Dynamic>) : Bool {
		if (cls != null)
			do {
				if (Type.resolveClass(cast(Reflect.field(cls, "__name__"), Array<Dynamic>).join(".")) == destCls)
					return true;
				
				cls = Reflect.field(cls, "__super__");
			}
			while (cls != null);
		
		return false;
	}
}