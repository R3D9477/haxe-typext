package rn.typext.hlp;

import sys.io.Process;

using StringTools;

class SysHelper {
	public static function getCpuArch () : Int {
		return (switch (Sys.systemName().toLowerCase()) {
			case "linux", "bsd", "mac":
				(new Process("uname", ["-i"])).stdout.readAll().toString();
			case "windows":
				(new Process("wmic", ["os", "get", "osarchitecture"])).stdout.readAll().toString();
			default:
				"";
		}).indexOf("64") >= 0 ? 64 : 32;
	}
}
