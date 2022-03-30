package;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import randomShit.util.DumbUtil;
import randomShit.dumb.FunnyReferences;
import flixel.FlxG.random as SusRandom;
using StringTools;

/**The speen.png file will be used here now.
    
@since March 2022 (Emo Engine 0.2.0)*/
class SpinningIcon extends FlxSprite {
    static inline final ANIM_XML:String = 'spinner go brr';
    static inline final LOOP_FRAMERATE:Int = 30;
    static var PLACE_X:Float;
    static var PLACE_Y:Float;
    var amogus:Int = 0;
    public function new(Corner:SpinCorner) {
        switch (Corner) {
            case BOTTOM_LEFT:
                PLACE_X = 0;
                PLACE_Y = flixel.FlxG.height - 48;
            case BOTTOM_RIGHT:
                PLACE_X = flixel.FlxG.width - 48;
                PLACE_Y = flixel.FlxG.height - 48;
            case TOP_LEFT:
                PLACE_X = 0;
                PLACE_Y = 0;
            case TOP_RIGHT:
                PLACE_X = flixel.FlxG.width - 48;
                PLACE_Y = 0;
        }
        super(PLACE_X, PLACE_Y);
        frames = FlxAtlasFrames.fromSparrow('assets/images/editor/speen.png', DumbUtil.getRawFile('assets/images/editor/speen.xml'));
        animation.addByPrefix('spinning', ANIM_XML, LOOP_FRAMERATE, true);
        animation.addByPrefix("sus", ANIM_XML, 0, false);
        animation.play('spinning');
    }

    override function update(elapsed:Float) {
        amogus = animation.curAnim.curFrame;
        super.update(elapsed);
    }

    public function spin() {
        if (animation.curAnim == null || animation.curAnim.name == 'sus') {
            animation.play('spinning');
        } else {
            flixel.FlxG.sound.play(Paths.sound("missnote1"));
            trace("ALREADY SPINNING!!");
        }
    }

    public function stopSpin() {
        animation.play('sus', false, false, amogus);
    }
}

enum SpinCorner {
    /**AMONG US*/
    BOTTOM_LEFT;
    /**oh wow i can actually describe these lmfao*/
    BOTTOM_RIGHT;
    /**oh hi top*/
    TOP_LEFT;
    /**are you sure you aren't a bottom?*/
    TOP_RIGHT;
}