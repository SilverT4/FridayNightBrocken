package random.helpMe;

import flixel.util.FlxTimer;
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
    public static function getRemainingBattery() {
        var intThing:Int;
        new Process("powershell", ["-command", "(Get-WmiObject Win32_Battery).EstimatedChargeRemaining", "> .\\battery.txt"]);
                if (FileSystem.exists("./battery.txt")) {
                    var penis = File.getContent("./battery.txt");
                    trace(penis);
                    //var semen = penis.split(' ');
                    intThing = Std.parseInt(penis);
                    trace(intThing);
                } else {
                    trace('*crashes cutely*');
                    throw new Exception('Something went wrong, please check the console.\n\n' + exceptionMessages[0]);
                }
        return intThing;
    }
    public static function getCurrentUser():String {
        /*new Process("whoami", ["> user.txt"]);
        var ass = File.getContent("user.txt");
        var moment = ass.split('\\');
        Sys.command("cmd", ["/c del user.txt"]); // WE DON'T NEED TO KEEP YOUR USERNAME THING IN THE FOLDER!
        return moment[1]; */
        return Sys.getEnv("USERNAME");
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
    public static function getCurrentWinNTVersion() {
        // new Process("powershell", ["-command", "(Get-WmiObject -class Win32_OperatingSystem).Version", ">" + Sys.getCwd() + "ver.txt"]);
        // new Process("powershell", ["-command", "(Get-WmiObject -class Win32_OperatingSystem)"]);
        new Process("powershell", ["-command", "systeminfo /fo CSV | ConvertFrom-Csv | select \"OS Version\", \"OS Name\" | Format-List > ver.txt"]);
        if (FileSystem.exists('./ver.txt')) {
            var banana = File.getContent('ver.txt');
            trace(banana);
            var ha = banana.split(':'); // see what i did there? banana split? i'm so funny hahahahahaha /s
            trace(ha);
            var jesus = ha[1].split('.');
            trace(jesus[0]);
            return knownWindowsNTVersions[Std.string(Std.parseInt(jesus[0])) + '.' + jesus[1]];
            // return jesus.toString();
        } else {
            throw new Exception('Something went wrong, please check the console.');
        }
    }
    public static function getPCMemoryAsString():String {
        new Process("powershell", ["-command", "(Get-WmiObject Win32_PhysicalMemory).Capacity", "> mem.txt"]);
        if (FileSystem.exists('./mem.txt')) {
            var initial = File.getContent('./mem.txt');
            //var cum = initial.split('\r\n');
            var capacityFromWmic:Int = Std.parseInt(initial);
            Sys.command("cmd", ['/c del mem.txt']); // don't need to keep the mem.txt once we're done with it!
            return Math.round(capacityFromWmic / 1073741824) + "GB (approx.)";
        } else {
            throw new Exception("Something went wrong, please check the console.\n\n" + exceptionMessages[0]);
        }
    }
    public static function getBasics():String {
        var infoArray:Array<String> = [];
        infoArray.push(getCurrentWinNTVersion());
        infoArray.push(Sys.getEnv("USERDOMAIN"));
        infoArray.push(getCurrentUser());
        infoArray.push(getPCMemoryAsString());
        trace(infoArray[0] + '\n' + infoArray[1] + '\n' + infoArray[2] + '\n' + infoArray[3]);
        return infoArray[0] + '\n' + infoArray[1] + '\n' + infoArray[2] + '\n' + infoArray[3];
    }

    public static function copyExternalFileToGameFolder(file:String, path:String) {
        new Process("cmd", ["/c copy " + file + " " + path]);
    }
}