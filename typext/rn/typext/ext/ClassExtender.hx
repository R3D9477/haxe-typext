package rn.typext.ext;

using StringTools;

class ClassExtender {
	public static function is (cls:Class<Dynamic>, destCls:Class<Dynamic>) : Bool {
		var coincidence:Bool = false;
		
		if (cls != null && destCls != null)
			do {
				coincidence = (cls == destCls);
				
				if (!coincidence) { // need for classes from binary modules
					var clsNameArr:Array<String> = Std.string(untyped cls.__name__).replace("[", "").replace("", "]").split(",");
					var destClsName:String = Type.getClassName(destCls);
					
					coincidence = (clsNameArr.join(".") == destClsName) || (clsNameArr.pop() == destClsName);
				}
				
				if (!coincidence)
					cls = untyped cls.__super__;
			}
			while (!coincidence && cls != null);
		
		return coincidence;
	}
}
