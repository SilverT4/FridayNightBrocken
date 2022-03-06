package shitpost;

import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.FlxG;
import haxe.SysTools;
import openfl.system.System;

using StringTools;
/**the funny white woman
    @since February 2022 or so (Emo Engine 0.1.1)*/
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
    /**do the funny*/
    public function whiteWomanJumpscare() {
        visible = true;
        animation.play('vanny');
        FlxG.sound.play(Paths.sound('jumpedYaMom'), 1);
    }
    /**oooOOOooooOOOOOOOoooo scary crasher 👻👻👻*/
    public function crashGame() {
        System.exit(0);
    }
}