package random.helpMe;

import sys.io.Process;
import haxe.Exception;
import Sys;
import openfl.system.Capabilities;
import sys.FileSystem;
import sys.io.File;
import haxe.Exception;
import sys.io.Process;

using StringTools;

/**a few utilities for Windows*/
class WindowsUtils {
    private static var exceptionMessages:Map<Int, String> = [
        0 => "This is most likely a result of the file requested by the state calling this function NOT existing.",
    ];
    public static function getRemainingBattery(outputPath:String) {
            new Process("cmd", ["/c susBattery.bat"]);
            if (FileSystem.exists(outputPath)) {
                var penis = File.getContent(outputPath);
                trace(penis);
                var semen = penis.split('\n');
                return semen[1];
            } else {
                throw new Exception('Something went wrong, please check the console.\n\n' + exceptionMessages[0]);
            }
    }
    public static function getCurrentUser():String {
        new Process("whoami", ["> user.txt"]);
        var ass = File.getContent("user.txt");
        var moment = ass.split('\\');
        Sys.command("cmd", ["/c del user.txt"]); // WE DON'T NEED TO KEEP YOUR USERNAME THING IN THE FOLDER!
        return moment[1];
    }
    private static final knownWindowsNTVersions:Map<String, String> = [
        "5.0" => "Windows 2000", // I doubt anyone would run FNF on that old of an OS but still.
        "5.1" => "Windows XP", // You're cool, but you should upgrade. Unless you're in a VM. Lol
        "6.0" => "Windows Vista", // Yes, Vista was nice.
        "6.1" => "Windows 7", // Good old Windows 7. I miss it. #RIPWindows7
        "6.2" => "Windows 8", // Ugh, why'd they have to remove the start menu :sob:
        "6.3" => "Windows 8.1", // BRINGING BACK THE START **BUTTON** IS NOT THE SAME AS BRINGING BACK THE START **MENU**, MICROSOFT!
        "10.0" => "Windows 10 OR Windows 11" // Also 11 since that shit doesn't have its own NT version for some reason!!
    ];
    public static function getCurrentWinVersion() {
        new Process("cmd", ["ver > ver.txt"]);
        if (FileSystem.exists('ver.txt')) {
            var banana = File.getContent('ver.txt');
            var jesus = banana.split('Microsoft Windows [Version '); // see what i did there? banana split? i'm so funny hahahahahaha /s
            var ha = jesus[1].split('.');
            return knownWindowsNTVersions[ha[0] + '.' + ha[1]];
        } else {
            throw new Exception('Something went wrong, please check the console.');
        }
    }
    public static function getPCMemoryAsString():String {
        new Process("wmic", ["/output:mem.txt memorychip get capacity"]);
        if (FileSystem.exists('mem.txt')) {
            var initial = File.getContent('mem.txt');
            var cum = initial.split('\r\n');
            var capacityFromWmic:Int = Std.parseInt(cum[1]);
            Sys.command("cmd", ['/c del mem.txt']); // don't need to keep the mem.txt once we're done with it!
            return Math.round(Std.parseFloat(Std.string(capacityFromWmic)) / 1073741824) + "GB (approx.)";
        } else {
            throw new Exception("Something went wrong, please check the console.\n\n" + exceptionMessages[0]);
        }
    }
    public static function getBasics():String {
        var infoArray:Array<String> = [];
        infoArray.push(getCurrentWinVersion());
        infoArray.push(Sys.getEnv("HOSTNAME"));
        infoArray.push(getCurrentUser());
        infoArray.push(getPCMemoryAsString());
        return infoArray[0] + '\n' + infoArray[1] + '\n' + infoArray[2] + '\n' + infoArray[3];
    }

    public static function copyExternalFileToGameFolder(file:String, path:String) {
        new Process("cmd", ["/c copy " + file + " " + path]);
    }
}