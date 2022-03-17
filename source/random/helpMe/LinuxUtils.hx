package random.helpMe;

import haxe.Exception;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import openfl.system.Capabilities;
import Sys;

using StringTools; //linux is a bitch idk if stringtools will work here

/**a few utilities for linux*/
class LinuxUtils {
    public static function getCurrentUser():String {
        return Std.string(Sys.command("whoami"));
    }
    public static function getMemory(?as:String):String {
        Sys.command("grep", ["MemTotal /proc/meminfo", "> mem.txt"]); // so we can set a variable with the mem info
        var bussy = File.getContent("mem.txt");
        Sys.command("rm", ["-v mem.txt"]); // we don't need mem.txt
        var shart = bussy.split('MemTotal: ');
        var teslaCvm = bussy.split(' ');
        switch (as) {
            case 'KB':
                return teslaCvm[0] + "KB";
            case 'MB':
                return Math.round(Std.parseFloat(teslaCvm[0]) / 1000) + "MB";
            case 'GB':
                return Math.round(Math.round(Std.parseFloat(teslaCvm[0]) / 1000) / 1000) + "GB";
            default:
                return shart[1];
        }
        return "AMONG US";
    }
    public static function getBasicInfo():String {
        var infoArray:Array<String> = [];
        infoArray.push(getMemory('GB'));
        infoArray.push(getCurrentUser());
        return "test";
    }
}