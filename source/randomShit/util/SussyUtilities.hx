package randomShit.util;

#if (!web && !mobile)
import sys.io.Process;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import lime.app.Application;
using StringTools;

/**These are all utilities that may trigger your computer's antivirus!!
    @since March 2022 (Emo Engine 0.1.2)*/
class SussyUtilities {
    static inline final TERMINAL = #if windows "cmd" #else "/bin/sh" #end;
    static inline final LS = #if windows "dir" #else "ls" #end;
    static final HOME = #if windows "C:\\Users\\" + Sys.getEnv("USERNAME") #elseif macos "/Users/" + Sys.getEnv("USERNAME") #elseif linux Sys.getEnv("HOME") #end;
    static var COMPANY:String = '';
    static var EXECUTABLE_NAME:String = '';
    static var SAVE_DIRECTORY:String = '';
    public static var FUNCTIONS_CEASED:Bool = false; // THIS GETS SET TO TRUE IF YOU SAY *YES* IN THE ANTIVIRUS STATE.
    public static function setupTheVars() {
        COMPANY = Application.current.meta["company"];
        EXECUTABLE_NAME = Application.current.meta["file"];
        SAVE_DIRECTORY = #if windows HOME + "\\AppData\\Roaming\\" + COMPANY + "\\" + EXECUTABLE_NAME + "\\fridayNightBrocken" #elseif macos HOME + "/Library/Application Support/" + COMPANY + "/" + EXECUTABLE_NAME + "/fridayNightBrocken" #elseif linux HOME + "/" #end;
    }
    public static function readExternalDirectory(DirectoryPath:String) {
        return FileSystem.readDirectory(DirectoryPath).join(', ').replace('.sol', '');
    }
}
#end