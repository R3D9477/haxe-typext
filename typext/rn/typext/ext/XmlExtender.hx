package rn.typext.ext;

import xpath.XPathHx;

using Lambda;

class XmlExtender {
	public static function getByXpath (xml:Xml, xpath:String) : Null<Xml>
		return (new XPathHx(xpath)).selectNode(xml);
	
	public static function findByXpath (xml:Xml, xpath:String) : Array<Xml>
		return (new XPathHx(xpath)).selectNodes(xml).array();
	
	public static function removeSelf (xml:Xml) : Void
		if (xml.parent != null)
			xml.parent.removeChild(xml);
	
	public static function replaceWith (xml:Xml, newXml:Xml) : Null<Xml> {
		var xmlParent:Xml = xml.parent;
		
		if (xmlParent != null) {
			xmlParent.removeChild(xml);
			xmlParent.addChild(newXml);
		}
		
		return newXml;
	}
	
	public static function clone (xml:Xml) : Null<Xml>
		return Xml.parse(xml.toString()).firstElement();
	
	public static function getChildAt (xml:Xml, index:Int) : Xml {
		var n = null;
		var i = 0;
		
		for (node in xml.elements()) {
			if (i <= index)
				n = node;
			else break;
			
			i++;
		}
		
		return n;
	}
}
