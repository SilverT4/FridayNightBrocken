package random.dumb;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import Paths;

using StringTools;

/**Just a quick setup for the default background.
@since March 2022 (Emo Engine v0.1.2)*/
class FunkyBackground extends FlxSprite {
    var DEFAULT_IMAGE:String = Paths.image('menuDesat');
    var funkyTween:FlxTween;
    static inline final DEFAULT_DURATION:Float = 0.75;

    public function new() {
        super();
        loadGraphic(DEFAULT_IMAGE);
        setGraphicSize(Std.int(this.width * 1.1));
        screenCenter();
    }
    /**Set the background colour. You can have it tween if you'd like.
        @param newColor The new colour
        @param tweens If you want to tween the colour to the new one, set this to true
        @param dur (Optional if tweens is false) How long the tween will take.
        @returns This object
        @since March 2022 (Emo Engine 0.1.2)*/
    public function setColor(newColor:FlxColor, tweens:Bool, ?dur:Float):FunkyBackground {
        if (tweens && dur != null) {
            funkyTween = FlxTween.tween(this, {"color": newColor}, dur, { onComplete: function(twn:FlxTween) {
                trace('pp');
            }});
        } else if (tweens && dur == null) {
            trace('default tween dur');
            funkyTween = FlxTween.tween(this, {"color": newColor}, DEFAULT_DURATION, { onComplete: function(twn:FlxTween) {
                trace('pp');
            }});
        } else {
            color = newColor;
        }
        return this;
    }
}