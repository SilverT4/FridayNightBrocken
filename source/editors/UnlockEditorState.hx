package editors;

import flixel.FlxCamera;
import flixel.ui.FlxBar;
import flixel.addons.ui.FlxUIButton;
import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end
import Conductor.BPMChangeEvent;
import Section.SwagSection;
import Song.SwagSong;
import Character;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUIBar;
import flixel.addons.ui.FlxUILoadingScreen;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import Random;
import openfl.net.FileReference;
import openfl.utils.ByteArray;
import openfl.utils.Assets as OpenFlAssets;
import lime.media.AudioBuffer;
import haxe.io.Bytes;
import flash.geom.Rectangle;
import flixel.util.FlxSort;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
import flash.media.Sound;
#end

using StringTools;

class UnlockEditorState extends MusicBeatState {
    var hardCoded:Array<Dynamic> = [
        ['SuspiciousFool', 'skin', 'Mini Saber', 'minisaber', 'unlockedMiniSaber'],
        ['Grass', 'skin', 'BF.xml', 'bf-opponent', 'unlockedBfOpponent'],
        ['KermitArson', 'skin', 'Flamestarter', 'arson', 'unlockedArsonist'],
        ['ExampleSongWord', 'song', 'Test', 'test', 'exampleSongUsed']
    ]; // explanation will be in the DOCS folder.
    var customUnlocks:Array<Dynamic> = []; // explanation will be in the DOCS folder
    var bruh:FlxBar;
    var speenLoad:FlxSprite;
    var speen:FlxSprite;
    var progressPercent:FlxText;
    var mainBackground:FlxSprite;
    var loadingBackground:FlxSprite;
    var testingBackground:FlxSprite;
    var camLoad:FlxCamera;
    var camMain:FlxCamera;
    var camTesting:FlxCamera;
    var testScreen:FlxUILoadingScreen;
    var curState:String = 'pants';

    public function new() {
        super();
        camMain = new FlxCamera();
        camMain.bgColor.alpha = 0;
        FlxG.cameras.add(camMain);
        retrieveCustomUnlockables();
    }

    override function update (elapsed:Float) {
        if (speenLoad != null) {
            speenLoad.update(elapsed);
        }
        if (speen != null) {
            speen.update(elapsed);
        }
        if (bruh != null) {
            bruh.update(elapsed);
        }
        if (progressPercent != null) {
            progressPercent.update(elapsed);
        }
        if (controls.BACK) {
            doExitChecks();
        }
    }

    function retrieveCustomUnlockables() {
        trace('now checking unlockables');
        var unlockDir:Dynamic = FileSystem.readDirectory('mods/unlockable');
        bruh = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 200, 20, null, 'files', 0, unlockDir.length, true);
        bruh.x = FlxG.width * 0.5;
        bruh.screenCenter(Y);
        bruh.cameras = [camLoad];
        speenLoad = new FlxSprite(FlxG.width - 48, FlxG.height - 48);
        speenLoad.frames = Paths.getSparrowAtlas('editor/speen');
        speenLoad.animation.addByPrefix('spin', 'spinner go brr', 30, true);
        speenLoad.animation.play('spin');
        add(speenLoad);
        for (i in 0...unlockDir) {

            if (unlockDir[i].endsWith('.txt')) {
                trace(Std.int(i + 1) + ' of ' + unlockDir.length + ': Skipping ' + unlockDir[i] + ' as it is not a JSON!');
            } else {
                trace(Std.int(i + 1) + ' of ' + unlockDir.length + ': Adding file ' + unlockDir[i] + ' to the list!');
                customUnlocks.push(unlockDir[i]);
            }
            if (i == unlockDir.length) {
                endLoadingShit();
            }
        }
    }

    function endLoadingShit() {

    }

    function doExitChecks() {
        switch (curState) {
            case 'pants':
                trace('wow, you pressed this REALLY early in the fuckin shit');
                MusicBeatState.switchState(new MasterEditorMenu());
            case 'farting':
                trace('aight lets confirm this');
                openSubState(new ConfirmExitDuringLoad());
        }
    }
}

class ConfirmExitDuringLoad extends MusicBeatSubstate {
    var confirmationBg:FlxSprite;
    var camConfirm:FlxCamera;
    var confirmationText:FlxText;
    var confirmationWindow:FlxSprite;
    var alphaMale:FlxTween;
    public var onFinish:Void->Void = null;

    public function new() {
        super();
        camConfirm = new FlxCamera();
        camConfirm.bgColor.alpha = 0;
        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
        }
    }

    override function update(elapsed:Float) {
        if (confirmationText != null) {
            confirmationText.update(elapsed);
        }
        if (confirmationWindow != null) {
            confirmationWindow.update(elapsed);
        }
        if (FlxG.keys.justPressed.Y) {
            MusicBeatState.switchState(new MasterEditorMenu());
            close();
        }
        if (FlxG.keys.justPressed.N) {
            close();
        }
    }

    override function create() {
        confirmationBg = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        confirmationBg.alpha = 0;
        confirmationBg.screenCenter();
        confirmationBg.cameras = [camConfirm];
        add(confirmationBg);
        new FlxTimer().start(0.69, function (tmr:FlxTimer) {
            if (confirmationBg.alpha != 0.5) {
                confirmationBg.alpha += 0.05;
            }
        }, 10);
        /* alphaMale = FlxTween.tween(this, {alpha: 0}, 0.69, {onComplete: function (twn:FlxTween) {
			alphaMale = FlxTween.tween(this, {alpha: 1}, 0.69, {
				startDelay: 2.5,
				onComplete: function(twn:FlxTween) {
					alphaMale = null;
					remove(this);
					if(onFinish != null) onFinish();
				}
			});
		}}); */ //might use this later idk
        confirmationWindow = new FlxSprite(0).makeGraphic(Std.int(FlxG.width * 0.5), Std.int(FlxG.height * 0.5), FlxColor.WHITE);
        confirmationWindow.screenCenter();
        confirmationWindow.cameras = [camConfirm];
        confirmationText = new FlxText(0, 0, FlxG.height);
        confirmationText.setFormat(Paths.font('funny.ttf'), 48, FlxColor.BLACK, CENTER, SHADOW, FlxColor.WHITE);
        confirmationText.text = 'Are you sure you want to cancel?\nY/N';
        confirmationText.cameras = [camConfirm];
        confirmationText.screenCenter();
    }
}