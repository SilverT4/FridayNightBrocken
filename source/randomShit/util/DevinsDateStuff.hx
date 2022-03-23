package randomShit.util;

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
/**A little class I set up as a means of getting some times.
    @since March 2022 (Emo Engine 0.1.1)*/
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
    /**Gets the current hour as an int.
        @since March 2022 (Emo Engine 0.1.1)*/
    public static function getHour():Int {
        var shit = convertToTimeShit();
        trace(shit);
        return shit;
    }
    /**Allows you to set up a clock. It can either be the time from when the function was called, or constantly updating.
        
        @param constantlyUpdating Is it constantly updating?
        @since March 2022 (Emo Engine 0.1.1)*/
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

    /**Gives you the month and date. This is used in the placeholder profile.
        @return Today's date.
        @since March 2022 (Emo Engine 0.1.2)*/
    public static function getTodaysDate() {
        var heh = currentTime.split('-');
        return [heh[1], heh[2].substr(0, heh[2].length - 8)];
    }
}