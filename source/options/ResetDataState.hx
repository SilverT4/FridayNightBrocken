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
    var warnBg:FlxSprite;
    var promptText:FlxText;
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
        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
            FlxG.mouse.useSystemCursor = true;
        }
        resetBG = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        resetBG.color = FlxColor.RED;
        resetBG.setGraphicSize(Std.int(resetBG.width * 1.1));
        resetBG.updateHitbox();
        resetBG.screenCenter();
        add(resetBG);
        bf = new Boyfriend(750, 150, 'bf');
        bf.setGraphicSize(Std.int(bf.width * 0.8));
        bf.updateHitbox();
        bf.dance();
        add(bf);

        confirmButton = new FlxButton(0, 500, 'Reset', function() {
            trace('this is a test');
            openSubState(new ConfirmResetData());
        });
        confirmButton.screenCenter(X);
        add(confirmButton);
        
        warnBg = new FlxSprite(0).makeGraphic(FlxG.width, 26, FlxColor.fromRGBFloat(0, 0, 0, 0.69));
        warnBg.y = FlxG.height - 26;
        add(warnBg);
        promptText = new FlxText(0, warnBg.y + 4, FlxG.width, 'WARNING: Clicking the reset button will delete ALL save data for the game! If you do not want to do this, press ESCAPE!', 16);
        promptText.setFormat(Paths.font('funny.ttf'), 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(promptText);
    }

    override function update(elapsed:Float) {
        if (controls.BACK) {
            LoadingState.loadAndSwitchState(new OptionsState());
        }
        if (bf != null && bf.visible) {
            bf.update(elapsed);
            if (bf.animation.curAnim.finished) {
                bf.playAnim('scared');
            }
        }
        if (confirmButton != null && confirmButton.visible) {
            confirmButton.update(elapsed);
        }
    }
}

/**
    Because the ResetDataState is for resetting your save data, I'm adding a confirmation screen.
*/
class ConfirmResetData extends MusicBeatSubstate {
    var warnSound:FlxSound;
    var infoSound:FlxSound;
    var warnBG:FlxSprite;
    var okButton:FlxButton;
    var cancelButton:FlxButton;

    public function new() {
        super();
        warnSound = new FlxSound();
        warnSound.loadEmbedded(Paths.sound('warning'));
        infoSound = new FlxSound();
        infoSound.loadEmbedded(Paths.sound('information'));
        // this was to make sure it worked | warnSound.play()
    }
    override function update(elapsed:Float) {
        if (controls.BACK) {
            close();
        }
    }
    override function create() {
        warnBG = new FlxSprite(100);
        warnBG.makeGraphic(1080, 520, FlxColor.WHITE);
        warnBG.screenCenter();
        add(warnBG);
    }
}