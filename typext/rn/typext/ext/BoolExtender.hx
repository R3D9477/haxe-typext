package rn.typext.ext;

import StringTools;

class BoolExtender {
	public static function fromString (v:Bool, str:String) : Bool
		return switch (str.toLowerCase()) {
			case "true": return true;
			case "false": return false;
			default: return v;
		}
}
