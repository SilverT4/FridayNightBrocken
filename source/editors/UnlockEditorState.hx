package editors;

import flixel.system.debug.interaction.tools.Pointer;
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
// import flixel.addons.ui.FlxUILoadingScreen;
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
    static inline final HEALTHBAR = 'healthBar';
    
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
    var speenArgs:Array<Dynamic> = [FlxG.width - 48, FlxG.height - 48, 'assets/images/editor/speen.png', 'assets/images/editor/speen.xml'];
    var progressPercent:FlxText;
    var mainBackground:FlxSprite;
    var loadingBackground:FlxSprite;
    var testingBackground:FlxSprite;
    var nt:Character;
    var miniSaber:Character; //these are for the hardcode bar colours
    var loadingCamera:FlxCamera;
    var camMain:FlxCamera;
    var camTesting:FlxCamera;
    var reverberation:Array<Dynamic> = [
        
        
        '                          _     ',
        '  _ __ _____   _____ _ __| |__  ',
        ' | \'__/ _ \\ \\ / / _ \\ \'__| \'_ \\ ',
        ' | | |  __/\\ V /  __/ |  | |_) |',
        ' |_|  \\___| \\_/ \\___|_|  |_.__/ ',
        '                                ',
        ''
        
    ];
    // var testScreen:FlxUILoadingScreen;
    var curState:String = 'pants';
    var UI_box:FlxUITabMenu;
    var UI_lmao:FlxUITabMenu;
    var squish:Dynamic;
    var succulentChicken:Array<String> = [];
    var juicyBeef:Array<Dynamic> = [];
    var mouthwateringBacon:Array<Dynamic> = [];
    var squishyJelly:Array<Dynamic> = [];
    var aromaticLettuce:Array<Dynamic> = [];
    var sexyProducts:Array<Dynamic> = [];
    var camHUD:FlxCamera;
    var camLmao:FlxCamera;
    var mainCams:Array<FlxCamera>;
    var TemplateUnlockable:String = '{
        "details": [
            {
                "contentType": "skin",
                "contentSubtype": "boyfriend",
                "contentFriendlyName": "Mini Saber",
                "contentIDName": "minisaber",
                "contentIsCharSkin": true,
                "contentIsNoteskin": false,
                "contentIsSong": false
            },
            {
                "skinPngPath": "mods/images/characters/BlitzBro.png",
                "skinXmlPath": "mods/images/characters/BlitzBro.xml",
            },
            {
                "noteskinPngPath": "",
                "noteskinPngXml": ""
            },
            {
                "songName": "",
                "songDifficulties": [
                    "-easy",
                    "",
                    "-hard"
                ]
            }
        ],
        "password": "SpookyButRed",
        "positioning": [
            "x": 0,
            "y": 0
        ]
    }'; // these will be explained in the docs as well
    
    public function new() {
        super();
        loadingCamera = new FlxCamera();
        loadingCamera.bgColor.alpha = 0;
        camMain = new FlxCamera();
        camMain.bgColor.alpha = 0;
        camTesting = new FlxCamera();
        camTesting.bgColor.alpha = 0;
        camHUD = new FlxCamera();
        camHUD.bgColor.alpha = 0;
        camLmao = new FlxCamera();
        camLmao.bgColor.alpha = 0;
        mainCams = [camMain, camHUD, camLmao];
        speenPreload = new FlxSprite(speenArgs[0], speenArgs[1]);
        speenPreload.frames = FlxAtlasFrames.fromSparrow(speenArgs[2], speenArgs[3]);
        speenPreload.animation.addByPrefix('spin', 'spinner go brr', 30, true);
        speenPreload.animation.play('spin');
        speenPreload.cameras = [loadingCamera];
        add(speenPreload);
        miniSaber = new Character(0, 0, 'minisaber', false);
        miniSaber.visible = false;
        add(miniSaber);
        nt = new Character(0, 0, 'nt-pixel', false);
        nt.visible = false;
        add(nt);
        FlxG.cameras.add(loadingCamera);
        convertHardCodeToArray();
        trace(FileSystem.readDirectory('mods/unlockable'));
    }
    var convertBg:FlxSprite;
    var speenPreload:FlxSprite;
    var convertBarBullshit:AttachedSprite;
    var convertBar:FlxUIBar;
    
    override function update (elapsed:Float) {
        if (speenLoad != null) {
            speenLoad.update(elapsed);
        }
        if (convertBar != null && convertBarBullshit != null) {
            convertBar.update(elapsed);
            convertBarBullshit.update(elapsed);
        }
        if (speenPreload != null) {
            speenPreload.update(elapsed);
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
        if (curState == 'shidding' && !FlxG.cameras.list.contains(mainCams[0])) {
            for (i in 0...mainCams.length) FlxG.cameras.add(mainCams[i]);
        }
        /* if (curState == 'shidding' && !FlxG.cameras.list.contains(camHUD)) {
            FlxG.cameras.add(camHUD);
        }
        if (curState == 'shidding' && !FlxG.cameras.list.contains(camLmao)) {
            FlxG.cameras.add(camLmao);
        }
        if (curState == 'pissing shit' && !FlxG.cameras.list.contains(camTesting)) {
            FlxG.cameras.add(camTesting);
        } */
    }

    function convertHardCodeToArray() {
        curState = 'suspicious';
        convertBg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        convertBg.color = FlxColor.RED;
        convertBg.scrollFactor.set();
        convertBg.cameras = [loadingCamera];
        add(convertBg);
        trace(convertBg);
        if (!speenPreload.isOnScreen(loadingCamera)) {
            speenPreload.reset(speenArgs[0], speenArgs[1]);
        }
        trace(speenPreload);
        convertBarBullshit = new AttachedSprite(HEALTHBAR);
        convertBarBullshit.graphic = Paths.image(HEALTHBAR);
        convertBarBullshit.y = FlxG.height * 0.89;
        convertBarBullshit.screenCenter(X);
        convertBarBullshit.scrollFactor.set();
        convertBarBullshit.visible = true;
        convertBarBullshit.cameras = [loadingCamera];
        add(convertBarBullshit);
        trace(convertBarBullshit);
        convertBar = new FlxUIBar(convertBarBullshit.x - 4, convertBarBullshit.y - 4, LEFT_TO_RIGHT, Std.int(convertBarBullshit.width - 8), Std.int(convertBarBullshit.height - 8), this, 'i', 0, hardCoded.length, true);
        convertBar.scrollFactor.set();
        convertBar.visible = true;
        convertBar.alpha = 1;
        convertBar.cameras = [loadingCamera];
        add(convertBar);
        convertBar.createFilledBar(FlxColor.fromRGB(miniSaber.healthColorArray[0], miniSaber.healthColorArray[1], miniSaber.healthColorArray[2]), FlxColor.fromRGB(nt.healthColorArray[0], nt.healthColorArray[1], nt.healthColorArray[2]));
        convertBar.updateBar();
        convertBarBullshit.sprTracker = convertBar;
        trace(convertBar);
        trace(convertBarBullshit);
        trace(loadingCamera);
        new FlxTimer().start(3, function (tmr:FlxTimer) {
            for (i in 0...hardCoded.length) {
                var hardDong:Array<Dynamic> = hardCoded[i];
                trace(hardDong);
                juicyBeef.push(hardDong[0]);
                trace(juicyBeef);
                mouthwateringBacon.push(hardDong[1]);
                trace(mouthwateringBacon);
                succulentChicken.push(hardDong[2]);
                trace(succulentChicken);
                squishyJelly.push(hardDong[3]);
                trace(squishyJelly);
                aromaticLettuce.push(hardDong[4]);
                trace(aromaticLettuce);
                if (i == hardCoded.length) {
                    if (FileSystem.readDirectory('mods/unlockable') != null && FileSystem.readDirectory('mods/unlockable').length > 1) retrieveCustomUnlockables() else displayMainUI();
                }
            }
        });
    }
    
    function retrieveCustomUnlockables() {
        trace('now checking unlockables');
        trace('fart with extra...');
        for (i in 0...reverberation.length) {
            trace(reverberation[i]);
        }
        curState = 'farting';
        loadingBackground = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        loadingBackground.color = FlxColor.BLUE;
        loadingBackground.scrollFactor.set();
        loadingBackground.cameras = [loadingCamera];
        add(loadingBackground);
        var unlockDir:Dynamic = FileSystem.readDirectory('mods/unlockable');
        var curFucker:Int = 0;
        bruh = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 200, 20, curFucker, 'files', 0, unlockDir.length, true);
        bruh.createGradientEmptyBar(FlxColor.gradient(FlxColor.BLUE, FlxColor.GREEN, 69), 1, 180, false);
        // bruh.facing = RIGHT;
        bruh.x = FlxG.width * 0.5;
        bruh.screenCenter(Y);
        bruh.cameras = [loadingCamera];
        add(bruh);
        speenLoad = new FlxSprite(FlxG.width - 48, FlxG.height - 48);
        speenLoad.frames = Paths.getSparrowAtlas(Paths.getPreloadPath('editor/speen'));
        speenLoad.animation.addByPrefix('spin', 'spinner go brr', ClientPrefs.framerate, true);
        speenLoad.animation.play('spin');
        // speenLoad.cameras = [loadingCamera];
        add(speenLoad);
        for (curFucker in 0...unlockDir) {
            bruh.updateBar();
            if (unlockDir[curFucker].endsWith('.txt')) {
                trace(Std.int(curFucker + 1) + ' of ' + unlockDir.length + ': Skipping ' + unlockDir[curFucker] + ' as it is not a JSON!');
            } else {
                trace(Std.int(curFucker + 1) + ' of ' + unlockDir.length + ': Adding file ' + unlockDir[curFucker] + ' to the list!');
                customUnlocks.push(unlockDir[curFucker]);
            }
            if (curFucker == unlockDir.length) {
                new FlxTimer().start(3, function (tmr:FlxTimer) {
                    endLoadingShit();
                });
            }
        }
    }
    
    function endLoadingShit() {
        speenLoad.destroy();
        loadingBackground.destroy();
        bruh.destroy();
        curState = 'shitting';
        displayMainUI();
        trace('placeholder to prevent any crashes');
    }
    
    function doExitChecks() {
        switch (curState) {
            case 'pants':
            trace('wow, you pressed this REALLY early in the fuckin shit');
            MusicBeatState.switchState(new MasterEditorMenu());
            case 'farting':
            trace('aight lets confirm this');
            openSubState(new ConfirmExitDuringLoad());
            case 'shidding':
            trace('aight');
            FlxG.sound.play(Paths.sound('cancelMenu', 'shared'));
            MusicBeatState.switchState(new MasterEditorMenu());
        }
    }
    
    function displayMainUI() {
        trace('im gonna brown');
        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
        }
        curState = 'shidding';
        mainBackground = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        mainBackground.color = 0xFF694200;
        mainBackground.scrollFactor.set();
        mainBackground.cameras = [camMain];
        add(mainBackground);
        var tabs = [
            {name: 'Unlockables', label: 'Unlockables'}
        ];
        UI_box = new FlxUITabMenu(null, tabs, true);
        UI_box.cameras = [camLmao];
        UI_box.resize(250, 120);
        UI_box.x = FlxG.width - 275;
        UI_box.y = 25;
        UI_box.scrollFactor.set();
        
        var tabs = [
            {name: 'Content Type', label: 'Content Type'},
            {name: 'Content Info', label: 'Content Info'},
            {name: 'Skin Paths', label: 'Skin Paths'},
            {name: 'Noteskin Paths', label: 'Noteskin Paths'},
            {name: 'Song Paths', label: 'Song Paths'}
        ];
        UI_lmao = new FlxUITabMenu(null, tabs, true);
        UI_lmao.cameras = [camLmao];
        UI_lmao.resize(350, 250);
        UI_lmao.x = UI_box.x - 100;
        UI_lmao.y = UI_box.y + UI_box.height;
        UI_lmao.scrollFactor.set();
        add(UI_lmao);
        add(UI_box);
        addUnlockListUI();
        addUnlockInfoUI();
        UI_lmao.selected_tab_id = 'Content Info';
    }
    
    var unlockDropDown:FlxUIDropDownMenuCustom;
    var curUnlockable:String;
    function addUnlockListUI() {
        var tab_group = new FlxUI(null, UI_box);
        tab_group.name = 'Unlockables';
        
        unlockDropDown = new FlxUIDropDownMenuCustom(10, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray(succulentChicken, true), function(unlockableName:String) {
            trace('pp');
            curUnlockable = unlockDropDown.selectedLabel;
        });
        trace('lets not crash pls');
    }
    
    function addUnlockInfoUI() {
        trace('lets also not crash pls');
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
        if (confirmationBg != null) {
            confirmationBg.update(elapsed);
        }
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
        confirmationWindow.alpha = 1;
        confirmationWindow.screenCenter();
        confirmationWindow.cameras = [camConfirm];
        confirmationText = new FlxText(0, 0, FlxG.height);
        confirmationText.setFormat(Paths.font('funny.ttf'), 48, FlxColor.BLACK, CENTER, SHADOW, FlxColor.WHITE);
        confirmationText.text = 'Are you sure you want to cancel?\nY/N';
        confirmationText.cameras = [camConfirm];
        confirmationText.screenCenter();
    }
}