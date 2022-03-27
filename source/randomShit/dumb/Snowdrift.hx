package randomShit.dumb;

import DialogueBoxPsych; // so i can copy his anims
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG; // for logging errors
import haxe.Json as SusJson;
import randomShit.util.DumbUtil.getRawFile as rawJsonSus;
using StringTools;

/**A custom FlxSprite class so I can attempt to use Snowdrift's dialogue portraits outside of dialogue boxes.
    @since March 2022 (Emo Engine 0.1.3)*/
class Snowdrift extends FlxSprite {
    static inline final texPath = 'shared:images/dialogue/snowdrift';
    static inline final dialogueJsonPath = 'default:images/dialogue/snowdrift.json';
    var animOffsets:Map<String, Array<Dynamic>> = [];
    public function new(x:Float, y:Float) {
        super(x, y);
        frames = getBird(texPath);
        addAnimsFromJson();
    }

    @:noCompletion private function addAnimsFromJson() {
        var diaChar:DialogueCharacterFile = cast SusJson.parse(rawJsonSus(dialogueJsonPath));
        for (anim in diaChar.animations) {
            animation.addByPrefix(anim.anim + '-idle', anim.idle_name, 24, true);
            animation.addByPrefix(anim.anim, anim.loop_name, 24, true);
            animOffsets[anim.anim + 'idle'] = anim.idle_offsets;
            animOffsets[anim.anim] = anim.loop_offsets;
        }
    }

    public function switchAnim(animName:String) {
        animation.play(animName, false);
        var daOffset = animOffsets.get(animName);
		if (animOffsets.exists(animName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
    }

    override function update(elapsed:Float) {
        if (animation.curAnim.finished && !animation.curAnim.name.contains('-idle')) {
            animation.play(animation.curAnim.name + '-idle');
        }
        super.update(elapsed);
    }

    @:noCompletion private function getBird(texture:String) {
        return FlxAtlasFrames.fromSparrow(texture + '.png', texture + '.xml');
    }
}