package rn.typext.ext;

using Lambda;
using StringTools;

class StringExtender {
	public static function repeat (str:String, count:Int) : String {
		var repeated = "";
		
		for (i in 0...count)
			repeated += str;
		
		return repeated;
	}
	
	public static function toDynamic (str:String) : Dynamic {
		var dyn:Dynamic;
		
		try {
			dyn = Std.parseInt(str);
		}
		catch(e:Dynamic) {
			try {
				dyn = Std.parseFloat(str);
			}
			catch(e:Dynamic) {
				if (str.toLowerCase() == "true")
					dyn = true;
				else if (str.toLowerCase() == "false")
					dyn = false;
				else
					dyn = str;
			}
		}
		
		return dyn;
	}
	
	public static function toCapitalLetterCase (str:String) : String
		return str.substr(0, 1).toUpperCase() + str.substr(1);
	
	public static function toTitleCase (str:String) : String
		return str.substr(0, 1).toUpperCase() + str.substr(1);
	
	public static function multiSplit (str:String, separators:Array<String>) : Array<String> {
		var result:Array<String> = [str];
		
		for (s in separators) {
			var i:Int = -1;
			
			while (++i < result.length)
				if (result[i].indexOf(s) >= 0)
					result = result.splice(0, i).concat(result[i].split(s)).concat(result.splice(i + 1, result.length));
		}
		
		return result;
	}
	
	public static function escNull (str:String) : String return str == null ? "" : str;
}
