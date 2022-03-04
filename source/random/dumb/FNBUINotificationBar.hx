package random.dumb;

import flixel.FlxG;
import flixel.tweens.FlxTween.FlxTweenManager;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxBasic;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import random.util.ColorUtil;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

using StringTools; //just in case

/**
    Custom notification bar that uses FlxSprites and FlxText to display a message.

    This thing ONLY really needs a text value and a Y value at the moment, as the bar just extends across the whole screen.

    *I plan to allow for customisation in the future, such as changing the colour of the notification bar and text.*
    
    *Hoping to make the text scroll across the screen as well.*
    @author devin503*/
class FNBUINotificationBar extends FlxSprite {
    private var message:String;
    public var msgDisplay:FNBNotificationText;
    public function new(text:String, y:Float) {
        super(0, y);

        message = text;

        makeGraphic(FlxG.width, 30, FlxColor.fromRGB(0, 128, 128, 235));
        alpha = 0; // BY DEFAULT IT'S 0.

        msgDisplay = new FNBNotificationText(this.x, y + 2, text);
        //msgDisplay.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.LEFT);
        //msgDisplay.visible = false;
    }
    var shittyTweenThing:FlxTween;
    /**Makes the message display on screen.*/
    public function show(duration:Int) {
        shittyTweenThing = FlxTween.tween(this, {alpha: 1}, 0.35, {onComplete: function(twn:FlxTween) {
            msgDisplay.alpha = 1;
            msgDisplay.scrollOnScreen();
            new FlxTimer().start(duration, function (tmr:FlxTimer) {
                msgDisplay.visible = false;
                msgDisplay.stopTweening();
                shittyTweenThing = FlxTween.tween(this, {alpha: 0}, 0.35, {onComplete: function (twn:FlxTween) {
                    trace('penis');
                }});
            });
        }});
    }

    override function update(elapsed:Float) {
        if (msgDisplay != null) {
            msgDisplay.update(elapsed);
        }

        super.update(elapsed);
    }

    public function changeMsg(newText:String) {
        msgDisplay.text = newText;
        msgDisplay.fieldWidth = newText.length * 2;
        msgDisplay.scrollFactor.set();
    }
}

/**Custom FlxText thing to add a tween thing ig*/
class FNBNotificationText extends FlxText {
    static var dumbassTweenThing:FlxTween;
    static var penis:FNBNotificationText;
    public function new (x:Float, y:Float, input:String) {
        super(x, y, input.length * 2, input, 24);

        scrollFactor.set();
        setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.LEFT); // just so it has the right format
        x = FlxG.width + 500;
        alpha = 0; // this'll be set to 1 when notification is displayed
        penis = this;
    }

    override function update (elapsed:Float) {
        super.update(elapsed);
    }

    public function scrollOnScreen() {
        dumbassTweenThing = FlxTween.tween(penis, {x: -500}, 10, {onComplete: function(twn:FlxTween) {
            penis.x = FlxG.width + 500;
        }, type: FlxTweenType.LOOPING});
    }
    public function stopTweening() {
        dumbassTweenThing.cancel();
        if (penis.x != FlxG.width + 500) {
            penis.x = FlxG.width + 500;
        }
    }
}