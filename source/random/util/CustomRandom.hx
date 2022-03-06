package random.util;

import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.FlxG;
/**A custom class that uses FlxRandom.
    @since February 2022 (Emo Engine 0.1.1)*/
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
        /**Generate a random integer between two different values.
            
        @param min Minimum number
        @param max Maximum number
        @since February 2022 (Emo Engine 0.1.1)*/
    public static function int(?min:Int = 0, max:Int):Int {
        random = new FlxRandom();
        return random.int(min, max);
    }
    /**Generate a random float between two different values.
        
    @param min Minimum float value
    @param max Maximum float value
    @since February 2022 (Emo Engine 0.1.1)*/
    public static function float(?min:Float = 0, max:Float):Float {
        random = new FlxRandom();
        return random.float(min, max);
    }
    /**Play a game of chance to determine the value of your bool.
        
    @param chance How likely will it be that your bool is true?
    @since February 2022 (Emo Engine 0.1.1)*/
    public static function bool(?chance:Float = 50) {
        random = new FlxRandom();
        return random.bool(chance);
    }
    /**Generate a random FlxColor. Recommended to use hex codes.
        
    @param min Minimum FlxColor value.
    @param max Maximum FlxColor value.
    @since February 2022 (Emo Engine 0.1.1)*/
    public static function colour(?min:FlxColor, max:FlxColor) {
        random = new FlxRandom();
        return random.color(min, max);
    }
}