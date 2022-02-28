package random.util;

import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.FlxG;

class CustomRandom {
    static var random:FlxRandom;

    public function new(type:String = 'Int', ?min:Dynamic = 0, max:Dynamic) {
        random = new FlxRandom();
    }
    /*switch (type) {
            case 'Int':
                return random.int(min, max);
            case 'Float':
                return random.float(min, max);
            case 'Bool':
                return random.bool(max); //use max as chance
            case 'Color' | 'Colour': //for the correct way (colour)
                return random.color(min, max);
        } */

    public static function int(?min:Int = 0, max:Int):Int {
        return random.int(min, max);
    }

    public static function float(?min:Float = 0, max:Float):Float {
        return random.float(min, max);
    }

    public static function bool(?chance:Float = 50) {
        return random.bool(chance);
    }

    public static function colour(?min:FlxColor, max:FlxColor) {
        return random.color(min, max);
    }
}