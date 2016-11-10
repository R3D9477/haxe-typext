package rn.typext.ext;

class ArrayExtender {
	public static function clear (array:Array<Dynamic>) {
		while (array.length > 0)
			array.pop();
		
		return array;
	}
	
	public static function moveTo (array:Array<Dynamic>, srcIndex:Int, destIndex:Int) {
		if (srcIndex != destIndex ) {
			var item = array[srcIndex];
			array.splice(srcIndex, 1);
			
			if (srcIndex < destIndex)
				destIndex--;
			
			array.insert(destIndex, item);
		}
	}
}
