package options;

import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;
import lime.app.Application;
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
import flixel.addons.ui.FlxUIPopup;
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
                bf.dance();
            }
        }
        if (confirmButton != null && confirmButton.visible) {
            confirmButton.update(elapsed);
        }
    }

	public static function destroyState() { FlxG.state.destroy(); }
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
    var warnText:FlxText;
    var speen:FlxSprite;
    var finishButton:FlxButton;
    var saveMessage:FlxUIPopup;
    var wtf:FlxUI;
    var wtftwo:FlxUITabMenu;

    public function new() {
        super();
        warnSound = new FlxSound();
        warnSound.loadEmbedded(Paths.sound('warning'));
        infoSound = new FlxSound();
        infoSound.loadEmbedded(Paths.sound('information'));
        FlxG.mouse.visible = true;
        // this was to make sure it worked | warnSound.play()
    }
    override function update(elapsed:Float) {
        if (controls.BACK) {
            close();
        }

        if (okButton != null && okButton.alive) {
            okButton.update(elapsed);
        }
        if (cancelButton != null && cancelButton.alive) {
            cancelButton.update(elapsed);
        }
        if (finishButton != null && finishButton.alive) {
            finishButton.update(elapsed);
        }
        if (warnText != null) {
            warnText.update(elapsed);
        }
        if (speen != null && speen.alive) {
            speen.update(elapsed);
        }
        if (wtftwo != null) {
            wtftwo.update(elapsed);
        }
    }
    override function create() {
        var overlays:FlxSprite = new FlxSprite(0);
        overlays.makeGraphic(1280, 720, FlxColor.BLACK);
        overlays.alpha = 0.69;
        add(overlays);
        warnBG = new FlxSprite(100);
        warnBG.makeGraphic(1080, 520, FlxColor.WHITE);
        warnBG.screenCenter();
        add(warnBG);
        var tabs = [
            { name: 'vore', label: 'bruh' }
        ]; //yes
        wtftwo = new FlxUITabMenu(null, tabs);
        wtftwo.resize(420, 420);
        wtftwo.screenCenter();
        wtftwo.color = 0xFFAACCFF;
        add(wtftwo);
        makeBullshitThingHappen();
        warnText = new FlxText(0, 150, 800, 'Are you COMPLETELY sure you want to reset your save data? This action is irreversable!', 24);
        warnText.setFormat(Paths.font('vcr.ttf'), 48, FlxColor.RED, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        warnText.screenCenter(X);
        add(warnText);
        okButton = new FlxButton(450, 450, 'RESET', function() {
            trace('ERASING!');
            okButton.kill();
            cancelButton.kill();
            warnText.text = 'Erasing your save data...';
            speen.revive();
            new FlxTimer().start(3, function (tmr:FlxTimer) {
                FlxG.save.erase();
                speen.kill();
                warnText.text = 'Save data erased. You must now restart the game.';
                finishButton.revive();
            });
        });
        okButton.color = FlxColor.RED;
        okButton.label.setFormat(Paths.font('funny.ttf'), 14, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.RED);
        add(okButton);
        cancelButton = new FlxButton(800, 450, 'Never mind', function() {
            close();
        });
        add(cancelButton);
        
        finishButton = new FlxButton(800, 450, 'Done', function() {
            trace('exiting');
            // Sys.exit(69);
            if (TitleState.currentProfile != null) {
                FlxG.save.bind('funkin', 'ninjamuffin99');
                Application.current.window.alert('Your profile data has been erased. Save data has been bound to the default\nto prevent any potential issues.\n\nYou can set your profile up again by choosing it from the launcher.', 'Notice');
                this.destroy();
                ResetDataState.destroyState();
                FlxG.resetGame();
            } else {
                Sys.println('SAVE DATA ERASED.');
                Application.current.window.alert('Save data erased.\nYou must restart the game.', 'Notice');
                Sys.exit(69);
            }
        });
        add(finishButton);
        speen = new FlxSprite(Std.int(1080 - 48), Std.int(520 - 48));
        speen.frames = Paths.getSparrowAtlas('editor/speen');
        speen.animation.addByPrefix('speen', 'spinner go brr', 60, true);
        speen.animation.play('speen');
        add(speen);
        speen.kill();
        finishButton.kill();
        warnSound.play();
    }

    function makeBullshitThingHappen() {
        wtf = new FlxUI(null, wtftwo);
        wtf.name = 'vore';
        
        saveMessage = new FlxUIPopup();
        saveMessage.quickSetup('Notice', 'Your profile data has been reset. As a result, save data will be bound to the default save to prevent any issues. To set up your save data again, just choose it from the launcher.', ['OK']);
        saveMessage.broadcastToFlxUI = true;
        saveMessage.draw();
        saveMessage.add(wtf);
        wtftwo.add(wtf);
    }
}