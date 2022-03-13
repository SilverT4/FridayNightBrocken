package random.util;

import PlayState;
import Character;
import Boyfriend;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

using StringTools;

/**A few dumb utils to save typing time, really. Idk
    @since Emo Engine 0.1.2 (March 2022)*/
class DumbUtil {
    // var PlayStation:PlayState;
    // static var BitchOne:Boyfriend;
    // static var BitchTwo:Character;

    public static function getBfAnim(AnimName:String):Bool {
        var PlayStation:PlayState = PlayState.instance;
        var BitchOne:Boyfriend = PlayStation.boyfriend;
        trace(BitchOne.animation.getByName(AnimName));
        if (BitchOne.animation.getByName(AnimName) != null) {
            return true;
        } else return false;
    }

    public static function getGfAnim(AnimName:String):Bool {
        var PlayStation:PlayState = PlayState.instance;
        var BitchTwo:Character = PlayStation.gf;
        trace(BitchTwo.animation.getByName(AnimName));
        if (BitchTwo.animation.getByName(AnimName) != null) {
            return true;
        } else return false;
    }

    public static function getDaddyAnim(AnimName:String):Bool {
        var PlayStation:PlayState = PlayState.instance;
        var BitchTwo:Character = PlayStation.dad;
        trace(BitchTwo.animation.getByName(AnimName));
        if (BitchTwo.animation.getByName(AnimName) != null) {
            return true;
        } else return false;
    }
}