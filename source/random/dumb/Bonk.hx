package random.dumb;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import PlayState;
import random.util.CustomRandom;
import random.dumb.BonkTest;

using StringTools; // idk if i need it

class Coconut extends FlxSprite {
    public var target:String = 'Dad';
    public var targetY:Float = 69; // yes
    private var bussyTween:FlxTween;
    private var fart:PlayState;
    private var shart:BonkTest;
    public var dealThis:Float = 0;

    public function new(x:Float, y:Float, targetChar:String) {
        super(x, y);
        if (PlayState.instance != null) fart = PlayState.instance;
        if (BonkTest != null) shart = BonkTest.instance;
        loadGraphic(Paths.image('coconut')); // YES, IT LOADS A PNG.
        setGraphicSize(256, 256);
        updateHitbox();
        target = targetChar;
    }

    public function fall() {
        trace('FALLING!!');
        bussyTween = FlxTween.tween(this, { y: targetY }, 0.321, { onComplete: bonk });
    }

    function bonk(twn:FlxTween) {
        trace('IMPACT!!');
        FlxG.sound.play(Paths.sound('bonk'));
        new FlxTimer().start(0.1, function(tmr:FlxTimer) {
            alpha -= 0.1;
        }, 11);
        if (dealThis != 0 && fart != null) {
            fart.doBonkShit(target, dealThis);
        } else if (fart != null) {
            fart.doBonkShit(target);
        } else if (shart != null) {
            trace('BONK!');
            shart.doFunnyStuff();
        }
    }

    public function resetCoconut() {
        y = -1000;
        alpha = 1;
        trace('reset bonk');
    }
}