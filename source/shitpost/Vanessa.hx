package shitpost;

import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.FlxG;
import haxe.SysTools;
import openfl.system.System;

using StringTools;
/**vussy*/
class Vanessa extends FlxSprite {
    public var readyToCrash:Bool = false;
    public function new(x:Float, y:Float) {
        super();
        frames = Paths.getSparrowAtlas('vanessa');
        animation.addByPrefix('vanny', 'You Get No Vussy Today, Sir', 24, false);
        animation.addByIndices('idle', 'You Get No Vussy Today, Sir', [0,1], null, 24, false);
        animation.play('idle');
        visible = false;
    }
    public function whiteWomanJumpscare() {
        visible = true;
        animation.play('vanny');
        FlxG.sound.play(Paths.sound('jumpedYaMom'), 1);
    }

    public function crashGame() {
        System.exit(0);
    }
}