package randomShit.util;

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
        @returns The resulting int
        @since February 2022 (Emo Engine 0.1.1)*/
    public static function int(?min:Int = 0, max:Int):Int {
        random = new FlxRandom();
        var here:Int = random.int(min, max);
        trace(here);
        return here;
    }
    /**Generate a random float between two different values.
        
    @param min Minimum float value
    @param max Maximum float value
    @returns The resulting float
    @since February 2022 (Emo Engine 0.1.1)*/
    public static function float(?min:Float = 0, max:Float):Float {
        random = new FlxRandom();
        var here:Float = random.float(min, max);
        trace(here);
        return here;
    }
    /**Play a game of chance to determine the value of your bool.
        
    @param chance How likely will it be that your bool is true?
    @returns True (if percent returned from FlxRandom is equal to or greater than `chance`), False (if percent is less than `chance`)
    @since February 2022 (Emo Engine 0.1.1)*/
    public static function bool(?chance:Float = 50) {
        random = new FlxRandom();
        var didYouWin:Bool = random.bool(chance);
        trace(didYouWin);
        return didYouWin;
    }
    /**Generate a random FlxColor. Recommended to use hex codes.
        
    @param min Minimum FlxColor value.
    @param max Maximum FlxColor value.
    @returns A random FlxColor.
    @since February 2022 (Emo Engine 0.1.1)*/
    public static function colour(?min:FlxColor, max:FlxColor) {
        random = new FlxRandom();
        var paint:FlxColor = random.color(min, max);
        trace(paint);
        return paint;
    }
    /**Pick a random item from an Array.
        
        *Allowing range specification is planned!*

    @param Arr The array to pick from
    @returns A random value from `Arr`.
    @since March 2022 (Emo Engine 0.1.2)*/
    public static function fromArray(Arr:Array<Dynamic>):Dynamic {
        return Arr[int(0, Arr.length)];
    }
}