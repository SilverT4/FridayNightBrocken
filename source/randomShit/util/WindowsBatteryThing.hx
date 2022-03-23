package randomShit.util;

import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
import haxe.SysTools;

using StringTools;

/**something dumb i'm coming up with. lmao
    @deprecated Superceded by `getRemainingBattery()` in [WindowsUtils](/source/random/helpMe/WindowsUtils.hx).*/
class WindowsBatteryThing {
    static var batteryCommandArray:Array<String> = [
        "path win32_battery",
        "get estimatedchargeremaining"
    ];
    public static function getCurrentLevel(?filePath:String) {
        if (filePath != null) {
            batteryCommandArray.insert(0, "/output:" + filePath);
        }
        return Sys.command('wmic', batteryCommandArray);
    }
}