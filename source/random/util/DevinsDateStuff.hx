package random.util;

import DateTools;
import Array;

using StringTools;
private typedef TimeyWimeyShit = {
    var hour:Int;
    var minute:Int;
    var second:Int;
    var date:Int;
    var month:Int;
    var year:Int;
}
class DevinsDateStuff {
    static var currentTime:String = Std.string(Date.now());
    var WibblyWobbly:TimeyWimeyShit;
    var ha:Array<Int>;
    static inline function convertToTimeShit():Int {
        var haha = currentTime.split('-');
        trace(haha);
        var bruh = haha[haha.length - 1].split(':');
        trace(bruh);
        return Std.parseInt(bruh[0]);
    }
    public static function getHour():Int {
        var shit = convertToTimeShit();
        trace(shit);
        return shit;
    }
    public static function dumbClock(?constantlyUpdating:Bool = false):String {
        if (constantlyUpdating) {
            currentTime = Std.string(Date.now());
            var fart = currentTime.split(' ');
            return fart[1];
        } else {
            var fart = currentTime.split(' ');
            return fart[1];
        }
    }
}