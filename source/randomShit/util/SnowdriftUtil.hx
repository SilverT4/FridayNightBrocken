package randomShit.util;

import sys.io.File as SnowFile;
import sys.FileSystem as SnowFS;
import Paths.snowdriftChatter as snowJson;
import haxe.Json.parse as Snowflake;

using StringTools;

/**Get the fuckin shit ig
    @since March 2022 (Emo Engine 0.1.2)*/
class SnowdriftUtil {
    public static function loadChatter(ChatterName:String) {
        return Snowflake(snowJson(ChatterName)); // quick return lmao
    }

    public static var birthdayOverride:Bool = false; // if this is set to true then any songs played have their opponent replaced with snowdrift!
}