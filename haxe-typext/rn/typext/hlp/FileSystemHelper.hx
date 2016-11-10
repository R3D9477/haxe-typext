package rn.typext.hlp;

import haxe.io.Path;
import sys.io.File;
import sys.io.FileOutput;
import sys.io.FileInput;
import sys.FileSystem;
import haxe.ds.GenericStack;
import sys.io.Process;

using StringTools;

class FileSystemHelper {
	public static function iterateFilesTree (dirPath:String, pathHandler:Dynamic) : Void {
		if (!FileSystem.exists(dirPath))
			return;
		
		var pathStack:GenericStack<String> = new GenericStack<String>();
		pathStack.add(FileSystem.absolutePath(dirPath));
		
		while(!pathStack.isEmpty()) {
			var currPath:String = pathStack.pop();
			
			pathHandler(currPath);
			
			if (FileSystem.isDirectory(currPath))
				for(childPath in FileSystem.readDirectory(currPath))
					pathStack.add(Path.join([currPath, childPath]));
		}
	}
	
	public static function copy (srcPath:String, destPath:String, mapBefore:Dynamic = null, mapAfter:Dynamic = null) : Void {
		if (mapBefore == null)
			mapBefore = function (file:String) : String return file;
		
		if (mapAfter == null)
			mapAfter = function (file:String) : Void return;
		
		srcPath = FileSystem.fullPath(srcPath);
		
		var rmPath:String;
		
		if (destPath != Path.removeTrailingSlashes(destPath)) {
			destPath = Path.addTrailingSlash(Path.join([FileSystem.fullPath(Path.directory(destPath)), Path.withoutDirectory(destPath)]));
			rmPath = Path.addTrailingSlash(Path.directory(srcPath));
		}
		else
			rmPath = srcPath;
		
		iterateFilesTree(srcPath, function (chSrc:String) {
			var chDest:String = mapBefore(Path.join([destPath, chSrc.replace(rmPath, "")]));
			
			if (chDest > "")
				if (FileSystem.isDirectory(chSrc))
					FileSystem.createDirectory(chDest);
				else if (chSrc != chDest)
					File.copy(chSrc, chDest);
			
			mapAfter(chDest);
		});
	}
	
	public static function delete (delFilePath:String) : Void {
		var delFiles:GenericStack<String> = new GenericStack<String>();
		iterateFilesTree(delFilePath, function (path:String) delFiles.add(path));
		
		while(!delFiles.isEmpty())
			if (FileSystem.isDirectory(delFiles.first()))
				FileSystem.deleteDirectory(delFiles.pop());
			else
				FileSystem.deleteFile(delFiles.pop());
	}
	
	public static function getRelativePath (srcPath:String, destPath:String) : String {
		var relative:String = "";
		
		if (FileSystem.exists(srcPath))
			if (!FileSystem.isDirectory(srcPath))
				srcPath = Path.directory(srcPath);
		
		srcPath = Path.addTrailingSlash(FileSystem.fullPath(srcPath));
		destPath = FileSystem.fullPath(destPath);
		
		if (Path.isAbsolute(destPath))
			while (destPath.indexOf(srcPath) < 0) {
				srcPath = Path.addTrailingSlash(Path.directory(Path.removeTrailingSlashes(srcPath)));
				relative = Path.join(["..", relative]);
			}
		
		destPath = destPath.replace(srcPath, "");
		
		if (relative == "" && destPath != "")
			if (destPath.substr(0, 1) == "\\" || destPath.substr(0, 1) == "/")
				destPath = Path.join([".", destPath]);
		
		return Path.normalize(Path.join([relative, destPath]));
	}
	
	public static function execUrl (url:String) : Void {
		switch (Sys.systemName().toLowerCase()) {
			case "linux", "bsd": (new Process("xdg-open", [url]));
			case "mac": (new Process("open", [url]));
			case "windows": (new Process("start", [url]));
			default:
		}
	}
	
	public static function appendFile (fileName:String, message:String) {
		var output:FileOutput = File.append(fileName, false);
		output.writeString(message);
		output.close();
	}
	
	public static function isTextFile (fileName:String) : Bool {
		return switch (Sys.systemName().toLowerCase()) {
			case "linux", "bsd", "mac":
				(~/charset=/g).match((new Process("file", ["-ib", fileName])).stdout.readAll().toString());
			default:
				(~/\0/g).match(File.getContent(fileName));
		}
	}
	
	public static function isHiddenFile (fileName:String) : Bool {
		return (switch (Sys.systemName().toLowerCase()) {
			case "linux", "bsd", "mac":
				Path.withoutDirectory(fileName).substring(0, 1) == ".";
			default:
				false;
		});
	}
	
	public static function getFileSignature (fileName:String) : String {
		// https://en.wikipedia.org/wiki/List_of_file_signatures
		// http://web.archive.org/web/20110804162350/http://toorcon.techpathways.com/uploads/headersig.txt
		// http://stackoverflow.com/questions/4744890/c-sharp-check-if-file-is-text-based
		
		//...
		//...
		//...
		
		return "";
	}
	
	public static function searchInFile (filePath:String, searchStruct:Dynamic) : String {
		if (!isTextFile(filePath))
			return "";
		
		var searchText:String = searchStruct.text;
		
		if (searchStruct.replaceWith > "") {
			File.saveContent(filePath, new EReg(searchText, searchStruct.matchCase ? "g" : "ig").replace(File.getContent(filePath), searchStruct.replaceWith));
			searchText = searchStruct.replaceWith;
		}
		
		if (!searchStruct.matchCase)
			searchText = searchText.toLowerCase();
		
		var searchRes:String = "";
		var stream:FileInput = File.read(filePath, false);
		
		var buff:String = " ";
		var position:Int = 1;
		
		while (buff.length < searchText.length) {
			try {
				buff += stream.readString(1);
			}
			catch(e:haxe.io.Eof) {
				break;
			}
			
			position++;
		}
		
		while(true) {
			try {
				buff = buff.substring(1, buff.length) + stream.readString(1);
			}
			catch(e:haxe.io.Eof) {
				break;
			}
			
			if ((searchStruct.matchCase ? buff : buff.toLowerCase()) == searchText)
				searchRes += (position - searchText.length) + ",";
			
			position++;
		}
		
		stream.close();
		
		if (searchRes.length > 0)
			searchRes = filePath + ":" + searchRes.substring(0, searchRes.length - 1) + "|";
		
		return searchRes;
	}
}
