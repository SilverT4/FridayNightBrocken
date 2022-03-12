package random.dumb;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import PlayState;
import random.util.CustomRandom;

using StringTools; // idk if i need it

class Coconut extends FlxSprite {
    public var target:String = 'Dad';
    public var targetY:Float = 69; // yes
    private var bussyTween:FlxTween;
    private var fart:PlayState = PlayState.instance;
    public var dealThis:Float = 0;

    public function new(x:Float, y:Float, target:String) {
        super(x, y);

        loadGraphic(Paths.image('coconut')); // YES, IT LOADS A PNG.
        setGraphicSize(256, 256);
        updateHitbox();
    }

    public function fall() {
        trace('FALLING!!');
        bussyTween = FlxTween.tween(this, { y: targetY }, CustomRandom.float(0.01, 1.75), { onComplete: bonk });
    }

    function bonk(twn:FlxTween) {
        trace('IMPACT!!');
        FlxG.sound.play(Paths.sound('bonk'));
        do {
            alpha -= 0.1;
        } while (alpha > 0);
        if (dealThis != 0) {
            fart.doBonkShit(target, dealThis);
        } else {
            fart.doBonkShit(target);
        }
    }
}