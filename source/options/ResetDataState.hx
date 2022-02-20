package options;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;
/**
    This state is a **dangerous state** if you do not know what you are doing!! All of your Friday Night Brocken save data will be erased if you go through with this!
*/
class ResetDataState extends MusicBeatState {
    var resetBG:FlxSprite;
    var bf:Boyfriend;
    var confirmButton:FlxButton;
    /**
        This sound will be played when you're asked to confirm!
        */
    var warningSound:FlxSound;
    var infoSound:FlxSound;

    public function new() {
        super();
        trace('oh god');
    }

    override function create() {
        resetBG = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        resetBG.setGraphicSize(Std.int(resetBG.width * 1.1));
        resetBG.updateHitbox();
        resetBG.screenCenter();
        add(resetBG);
        bf = new Boyfriend(400, 150, 'bf');
        bf.dance();
        add(bf);
    }

    override function update(elapsed:Float) {
        if (controls.BACK) {
            LoadingState.loadAndSwitchState(new OptionsState());
        }
        if (bf != null) {
            bf.update(elapsed);
        }
    }
}