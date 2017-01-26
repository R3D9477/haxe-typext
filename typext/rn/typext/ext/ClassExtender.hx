package rn.typext.ext;

using StringTools;

class ClassExtender {
	public static function is (cls:Class<Dynamic>, destCls:Class<Dynamic>) : Bool {
		var coincidence:Bool = false;
		
		if (cls != null)
			do {
				coincidence = (cls == destCls);
				
				if (!coincidence)
					coincidence = (Type.resolveClass(Std.string(untyped cls.__name__).replace("[", "").replace("", "]").replace(",", ".")) == destCls); // need for classes from binary modules
				
				if (!coincidence)
					cls = untyped cls.__super__;
			}
			while (!coincidence && cls != null);
		
		return coincidence;
	}
}
