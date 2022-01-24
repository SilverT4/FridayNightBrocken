package;

import flixel.addons.ui.FlxUIButton;
import flixel.util.FlxTimer;
import editors.EditorPlayState;
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

class PasswordState extends MusicBeatState
{
    static var passwordList:Array<String> = // Type any passwords you want to create here. If you know how to handle txt files in FNF, let me know how to implement that kind of thing. I'd love to improve this. Lol
    [
        'SuspiciousFool',
        'Grass',
        'KermitArson',
        'ExampleSongWord'
        // 'Amogus'
        /* 'YouReallyWantTheBlueBoi',
        'BosipBestShipOC',
        'ThoseShoesAreKindaSmall' */
    ];
    var unlocks:Array<Dynamic>;
    var hen:Character;
    var pwInputBox:FlxUIInputText;
    var pwValidateButton:FlxButton;
    var pwPromptText:FlxText;
    var miniSaber:FlxSprite;
    var youIdiot:FlxSprite;
    var finishedCheck:Bool;
    var exitingMenu:Bool = false;
    var bfOpponent:FlxSprite;
    var bg:FlxSprite;
    var sussyFlags:Array<String> = [/* 'unlockedBosipNotes', 'unlockedBobNotes', 'unlockedMiniShoeyNotes', */'unlockedMiniSaber', 'unlockedBfOpponent', 'unlockedArsonist'];
    var sussyText:FlxText;
    /* var hahaBosip:FlxText;
    var hahaBob:FlxText;
    var hahaMiniShoey:FlxText; */
    var hahaSaber:FlxText;
    var hahaBfOp:FlxText;
    var hahaArson:FlxText;
    /* var ohnoBosip:FlxText;
    var ohnoBob:FlxText;
    var ohnoMiniShoey:FlxText; */
    var ohnoSaber:FlxText; 
    var ohnoBfOp:FlxText;
    var ohnoArson:FlxText;
    var sussyBg:FlxSprite;
    var contentTypes:Array<String> = ['Character', 'Song', 'Noteskin'];
    private var shaderArray:Array<ColorSwap> = [];
    var lockedShader:ColorSwap = new ColorSwap();
    var usedPasswords:Array<String>;
    var contentString:String;
    var unlockedContent:Array<Dynamic>;
    var useInstructions:Array<String>;
    var dbgPasswd:String;
    var needPasswd:Bool = false;
    var dbgNotice:FlxText;
    var dbgNoticeBg:FlxSprite;
    
    
    public function new() {
        super();
        #if debug
        if (!FileSystem.exists('assets/data/JOEMAMA.TXT')) {
            needPasswd = true;
            openSubState(new DebugPasswordShit());
        } else {
            dbgPasswd = sys.io.File.getContent('assets/data/JOEMAMA.TXT');
        }
        #end
        if (FlxG.save.data.usedPasswords == null) {
            FlxG.save.data.usedPasswords = [''];
            trace(FlxG.save.data.usedPasswords);
            FlxG.save.data.usedPasswords.push('your mom');
            usedPasswords = FlxG.save.data.usedPasswords;
        } else {
            trace(FlxG.save.data.usedPasswords);
            // FlxG.save.data.usedPasswords = ['your mom'];
            usedPasswords = FlxG.save.data.usedPasswords;
        }
        /* hahaBosip = new FlxText(0, 26, FlxG.width, '');
        hahaBob = new FlxText(0, 52, FlxG.width, '');
        hahaMiniShoey = new FlxText(0, 78, FlxG.width, ''); */
        hahaSaber = new FlxText(0, 104, FlxG.width, '');
        hahaBfOp = new FlxText(0, 130, FlxG.width, '');
        hahaArson = new FlxText(0, 156, FlxG.width, '');
        /* ohnoBosip = new FlxText(0, 26, FlxG.width, '');
        ohnoBob = new FlxText(0, 52, FlxG.width, '');
        ohnoMiniShoey = new FlxText(0, 78, FlxG.width, ''); */
        ohnoSaber = new FlxText(0, 104, FlxG.width, '');
        ohnoBfOp = new FlxText(0, 130, FlxG.width, '');
        ohnoArson = new FlxText(0, 156, FlxG.width, '');
        if (!FlxG.mouse.visible) FlxG.mouse.visible = true;
    }
    override function create()
        {
        #if desktop
        // Updating Discord Rich Presence lmfao why tho
        DiscordClient.changePresence("Being sussy", null, 'bf');
        #end
        trace('adding bullshit');
        useInstructions = [];
        pwInputBox = new FlxUIInputText(0, 0, 500, '', 16, FlxColor.BLACK, FlxColor.WHITE);
        if (!needPasswd && finishedCheck && !exitingMenu) {
            finishedCheck = false;
            checkSus();
        } else if (needPasswd) {
            trace('lets get a password lmfao');
            FlxG.sound.music.stop();
            FlxG.sound.playMusic(Random.fromArray(FileSystem.readDirectory('assets/songs/')) + '/Inst.ogg', 1, true);
        } else {
            trace('sussy');
            checkSus();
        }
    }
    override function update(elapsed:Float) {
        if (controls.BACK && !pwInputBox.hasFocus) {
            FlxG.sound.play('mods/sounds/jumpedYaMom.ogg'); // hate the paths system challenge /j
            if (finishedCheck) MusicBeatState.switchState(new MainMenuState()) else Sys.exit(420);
        }
        
        if (finishedCheck && controls.ACCEPT && !pwInputBox.hasFocus) {
            trace('what are you doing this is graphical');
        } else if (!finishedCheck && controls.ACCEPT && !pwInputBox.hasFocus) {
            trace('sussy');
            Sys.exit(69);
        }
        if (miniSaber != null) {
            miniSaber.update(elapsed);
        }
        if (youIdiot != null) {
            youIdiot.update(elapsed);
        }
        if (bfOpponent != null) {
            bfOpponent.update(elapsed);
        }
        if (hen != null) {
            hen.update(elapsed);
            if (hen.animation.curAnim.finished) {
                trace('haha beat my balls');
                hen.playAnim('idle');
            } else if (hen.animation.curAnim == null) {
                hen.playAnim('scared');
            }
        }
        if (pwInputBox != null) {
            pwInputBox.update(elapsed);
        }
        if (pwValidateButton != null) {
            pwValidateButton.update(elapsed);
        }
    }
    function checkSus() {
        trace('CHECKING YOUR SAVE DATA...');
        sussyBg = new FlxSprite(-80).makeGraphic(1280, 720, FlxColor.BLUE, false);
        sussyBg.scrollFactor.set(0, 0);
        sussyBg.setGraphicSize(Std.int(sussyBg.width * 1.175));
        sussyBg.updateHitbox();
        sussyBg.screenCenter();
        add(sussyBg);
        
        sussyText = new FlxText(0, 0, FlxG.width, 'Checking save data...', 24);
        add(sussyText);
        
        for (i in 0...sussyFlags.length) {
            trace('checking flag ' + i + ' of ' + sussyFlags.length + ' (' + sussyFlags[i] + ')');
            trace(i);
            prepMainCreate(i);
            switch (sussyFlags[i]) {
                /* case 'unlockedBosipNotes':
                if (FlxG.save.data.unlockedBosipNotes != null) {
                    trace('flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedBosipNotes);
                    hahaBosip.text = 'flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedBosipNotes;
                    add(hahaBosip);
                } else {
                    trace('flag ' + sussyFlags[i] + ' does not exist. initializing...');
                    FlxG.save.data.unlockedBosipNotes = false;
                    ohnoBosip.text = 'flag ' + sussyFlags[i] + ' does not exist, initializing...';
                    add(ohnoBosip);
                }
                case 'unlockedBobNotes':
                if (FlxG.save.data.unlockedBobNotes != null) {
                    trace('flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedBobNotes);
                    hahaBob.text = 'flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedBobNotes;
                    add(hahaBob);
                } else {
                    trace('flag ' + sussyFlags[i] + ' does not exist. initializing...');
                    FlxG.save.data.unlockedBobNotes = false;
                    ohnoBob.text = 'flag ' + sussyFlags[i] + ' does not exist, initializing...';
                    add(ohnoBob);
                }
                case 'unlockedMiniShoeyNotes':
                if (FlxG.save.data.unlockedMiniShoeyNotes != null) {
                    trace('flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedMiniShoeyNotes);
                    hahaMiniShoey.text = 'flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedMiniShoeyNotes;
                    add(hahaMiniShoey);
                } else {
                    trace('flag ' + sussyFlags[i] + ' does not exist. initializing...');
                    FlxG.save.data.unlockedMiniShoeyNotes = false;
                    ohnoMiniShoey.text = 'flag ' + sussyFlags[i] + ' does not exist, initializing...';
                    add(ohnoMiniShoey);
                } */
                case 'unlockedArsonist':
                if (FlxG.save.data.unlockedArsonist != null) {
                    trace('flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedArsonist);
                    hahaArson.text = 'flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedArsonist;
                    add(hahaArson);
                } else {
                    trace('flag ' + sussyFlags[i] + ' does not exist. initializing...');
                    FlxG.save.data.unlockedArsonist = false;
                    ohnoArson.text = 'flag ' + sussyFlags[i] + ' does not exist, initializing...';
                    add(ohnoArson);
                }
                case 'unlockedMiniSaber':
                if (FlxG.save.data.unlockedMiniSaber != null) {
                    trace('flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedMiniSaber);
                    hahaSaber.text = 'flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedMiniSaber;
                    add(hahaSaber);
                } else {
                    trace('flag ' + sussyFlags[i] + ' does not exist. initializing...');
                    FlxG.save.data.unlockedMiniSaber = false;
                    ohnoSaber.text = 'flag ' + sussyFlags[i] + ' does not exist, initializing...';
                    add(ohnoSaber);
                }
                case 'unlockedBfOpponent':
                if (FlxG.save.data.unlockedBfOpponent != null) {
                    trace('flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedBfOpponent);
                    hahaBfOp.text = 'flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedBfOpponent;
                    add(hahaBfOp);
                    prepMainCreate(sussyFlags.length);
                } else {
                    trace('flag ' + sussyFlags[i] + ' does not exist. initializing...');
                    FlxG.save.data.unlockedBfOpponent = false;
                    ohnoBfOp.text = 'flag ' + sussyFlags[i] + ' does not exist, initializing...';
                    add(ohnoBfOp);
                    prepMainCreate(sussyFlags.length);
                }
                
            }
            
        }
    }
    function trueCreate() {
        /* if (FlxG.sound.music.playing || FlxG.sound.music == null) {
            FlxG.sound.music.stop();
            FlxG.sound.playMusic(Paths.music('mktFriends', "shared"), 1);
        } // THE MUSIC HERE IS GITIGNORED, JUST LET THE GAME PLAY THE DEFAULT */
        bg = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
        bg.scrollFactor.set(0, 0);
        bg.setGraphicSize(Std.int(bg.width * 1.175));
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        bg.color = FlxColor.fromRGB(69, 0, 0);
        add(bg);
        #if debug
        dbgNoticeBg = new FlxSprite(0).makeGraphic(FlxG.width, 26, 0xFF000000);
        dbgNoticeBg.alpha = 0.6;
        add(dbgNoticeBg);
        dbgNotice = new FlxText(dbgNoticeBg.x, dbgNoticeBg.y + 4, FlxG.width, "You're running the game as a debug build. Feel free to mess with the passwords to your heart's content.");
        dbgNotice.setFormat(Paths.font("funny.ttf"), 16, FlxColor.WHITE, CENTER);
        dbgNotice.scrollFactor.set();
        add(dbgNotice);
        #end
        
        hen = new Character(FlxG.width * 0.6, FlxG.height * 0.2, 'henry', false);
        hen.setGraphicSize(256, 256);
        hen.playAnim('idle');
        add(hen);
        
        
        pwInputBox.x = FlxG.width * 0.21;
        pwInputBox.y = FlxG.height * 0.21;
        // pwInputBox.screenCenter();
        pwInputBox.updateHitbox();
        add(pwInputBox);
        
        pwPromptText = new FlxText();
        pwPromptText.x = pwInputBox.x - 100;
        pwPromptText.y = pwInputBox.y - 50;
        pwPromptText.text = 'Enter a password below. Anything you have unlocked\nalready will be shown in colour\nbelow, anything you have NOT will be black.';
        pwPromptText.width = FlxG.width;
        pwPromptText.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(pwPromptText);
        
        pwValidateButton = new FlxButton(0, 0, "Validate", function() {
            validateInput(pwInputBox.text);
        });
        pwValidateButton.x = pwInputBox.x + 100;
        pwValidateButton.y = pwInputBox.y + 100;
        pwValidateButton.updateHitbox();
        add(pwValidateButton);
        miniSaber = new FlxSprite(FlxG.width * 0.1, FlxG.height * 0.4);
        miniSaber.frames = FlxAtlasFrames.fromSparrow('mods/images/characters/MiniSaber.png', 'mods/images/characters/MiniSaber.xml');
        miniSaber.setGraphicSize(256, 256);
        miniSaber.animation.addByPrefix('idle', 'MSS idle dance', 24, true);
        miniSaber.animation.addByPrefix('hey', 'MSS PEACE', 24, false);
        miniSaber.animation.play('idle');
        if (!FlxG.save.data.unlockedMiniSaber) miniSaber.shader = lockedShader.shader;
        lockedShader.brightness = -100;
        add(miniSaber);

        bfOpponent = new FlxSprite(FlxG.width * 0.3, FlxG.height * 0.4);
        if (FileSystem.exists('mods/images/characters/BOYFRIEND.png')) bfOpponent.frames = FlxAtlasFrames.fromSparrow('mods/images/characters/BOYFRIEND.png', 'mods/images/characters/BOYFRIEND.xml') else bfOpponent.frames = FlxAtlasFrames.fromSparrow('assets/shared/images/characters/BOYFRIEND.png', 'assets/shared/images/characters/BOYFRIEND.xml');
        bfOpponent.setGraphicSize(256, 256);
        bfOpponent.animation.addByPrefix('fard', 'BF idle dance', 24, true);
        bfOpponent.animation.addByPrefix('shid', 'BF HEY', 24, false);
        bfOpponent.animation.play('fard');
        bfOpponent.flipX = true;
        if (!FlxG.save.data.unlockedBfOpponent) bfOpponent.shader = lockedShader.shader;
        add(bfOpponent);
        youIdiot = new FlxSprite(FlxG.width * 0.69, FlxG.height * 0.4);
        youIdiot.frames = FlxAtlasFrames.fromSparrow('mods/images/characters/Arsonist.png', 'mods/images/characters/Arsonist.xml');
        youIdiot.setGraphicSize(256, 256);
        youIdiot.animation.addByPrefix('actingsus', 'BF idle dance', 24, true);
        youIdiot.animation.addByPrefix('venting', 'BF HEY', 24, false);
        youIdiot.animation.play('actingsus');
        if (!FlxG.save.data.unlockedArsonist) youIdiot.shader = lockedShader.shader;
        add(youIdiot);
    }
    
    function validateInput(funnyWord:String) {
        trace('Checking input: ' + funnyWord);
        trace(passwordList);
        trace(usedPasswords);
        new FlxTimer().start(1.5, function (tmr:FlxTimer) {
            if (passwordList.contains(funnyWord) && !usedPasswords.contains(funnyWord)) {
                trace('Password good!');
                beginUnlockShit(funnyWord);
                // displayResultMsg(0);
            } else if (passwordList.contains(funnyWord) && usedPasswords.contains(funnyWord)) {
                trace('Password good, but already used!');
                displayResultMsg(2, 3);
            } else if (funnyWord == dbgPasswd) {
                for (i in 1...usedPasswords.length) {
                    trace(Std.int(i + 1) + ' of ' + usedPasswords.length + ': Removing ' + usedPasswords[i] + ' from the used passwords in your save data');
                    FlxG.save.data.usedPasswords.pop(usedPasswords[i]);
                }
                displayResultMsg(3, 3);
            } else {
                trace('Invalid password. Check spelling maybe?');
                displayResultMsg(1, 3);
            }
        });
    }
    
    function beginUnlockShit(funnyWords:String) {
        trace('Just a sec...');
        FlxG.save.data.usedPasswords.push(funnyWords);
        switch (funnyWords) {
            case 'SuspiciousFool': 
                trace('unlocking mini saber');
                setUnlockedContent(0);
                #if debug
                displayResultMsg(0, 1, ['boyfriend', 'mod character', 'Mini Saber', 'skin', 0, 'mss']);
                trace('dry run');
                #else
                unlockCharacter(['', '-opponent'], 'minisaber');
                displayResultMsg(0, 1, ['boyfriend', 'mod character', 'Mini Saber', 'skin', 0, 'mss']);
                FlxG.save.data.unlockedMiniSaber = true;
                #end
                miniSaber.shader = null;
                miniSaber.animation.play('hey');
            case 'Grass':
                trace('unlocking bf opponent');
                bg.color = FlxColor.fromRGB(0, 69, 0);
                setUnlockedContent(0);
                #if debug
                displayResultMsg(0, 1, ['opponent', 'mod character', 'BF.xml', 'skin', 0, 'bf-opponent']);
                trace('dry run');
                #else
                unlockCharacter(['-opponent'], 'bf');
                displayResultMsg(0, 1, ['opponent', 'mod character', 'BF.xml', 'skin', 0, 'bf-opponent']);
                FlxG.save.data.unlockedBfOpponent = true;
                #end
                bfOpponent.shader = null;
                bfOpponent.animation.play('shid');
            case 'KermitArson':
                trace('unlocking arsonist');
                setUnlockedContent(0);
                #if debug
                displayResultMsg(0, 1, ['boyfriend', 'mod character', 'Flamestarter', 'skin', 0, 'arson']);
                trace('dry run');
                #else
                unlockCharacter([''], 'arson');
                displayResultMsg(0, 1, ['boyfriend', 'mod character', 'Flamestarter', 'skin', 0, 'arson']);
                FlxG.save.data.unlockedArsonist = true;
                #end
                youIdiot.shader = null;
                youIdiot.animation.play('venting');
            case 'ExampleSongWord':
                trace('test song');
                setUnlockedContent(1);
                #if debug
                displayResultMsg(0, 1, ['example', 'example song', 'Test', 'song', 1, 'test']);
                trace('dry run');
                #else
                unlockSong(test, ['']);
                displayResultMsg(0, 1, ['example', 'example song', 'Test', 'song', 1, 'test']);
                FlxG.save.data.exampleSongUsed = true;
                #end
            /* case 'YouReallyWantTheBlueBoi':
                trace('unlocking bob notes');
                unlockNoteskin('bob');
            case 'ThoseShoesAreKindaSmall':
                trace('unlocking mini notes');
                unlockNoteskin('minishoey');
            case 'BosipBestShipOC':
                trace('unlocking bosip notes');
                unlockNoteskin('minishoey'); */
        }
    }
    function unlockCharacter(charVars:Array<String>, charName:String) {
        #if debug
        trace('dry run bc somehow we bypassed idk');
        #else
        for (i in 0...charVars.length) {
            trace(i + ' of ' + charVars.length + ': copying variation ' + charVars[i] + ' to characters folder...');
            File.copy('assets/locked/characters/' + charName.toLowerCase() + charVars[i] + '.json', 'mods/characters/' + charName.toLowerCase() + charVars[i] + '.json');
        }
        #end
    }
    
    function unlockNoteskin(skinName:String, ?folderName:String = 'funnyNotes') {
        var fileTypes:Array<String> = ['.png', '.xml'];
        for (i in 0...1) {
            File.copy('assets/locked/noteskins/' + skinName + fileTypes[i], 'mods/images/' + folderName + '/' + skinName + fileTypes[i]);
        }
        switch (skinName) {
            /* case 'bosip':
            FlxG.save.data.unlockedBosipNotes = true;
            trace('bosip skin unlocked');
            case 'bob':
            FlxG.save.data.unlockedBobNotes = true;
            trace('bob skin unlocked');
            case 'minishoey':
            FlxG.save.data.unlockedMiniShoeyNotes = true;
            trace('mini notes unlocked'); */
            default:
                trace('ass'); //placeholder
        }
    }
    
    function unlockSong(songName:String, ?diffics:Array<String>, ?needsVoices:Bool) {
        var diffics:Array<String> = ['-easy', '', '-hard'];
        for (i in 0...diffics.length) {
            trace(i + ' of ' + diffics.length + ': copying file ' + songName + diffics[i] + '.json to mods folder');
            File.copy('assets/locked/songs/' + songName + '/data/' + songName + diffics[i] + '.json', 'mods/data/' + songName + '/' + songName + diffics[i] + '.json');
        }
        var copyThese:Array<String> = ['Inst', 'Voices'];
        var copyOnlyInst:String = 'Inst';
        if (needsVoices != null && !needsVoices) {
            File.copy('assets/locked/songs/' + songName + '/audio/' + copyOnlyInst + '.ogg', 'mods/songs/' + songName + '/' + copyOnlyInst + 'ogg');
        } else if (needsVoices == null && FileSystem.exists('assets/locked/songs/' + songName + '/audio/Voices.ogg')) {
            for (i in 0...copyThese.length) {
                File.copy('assets/locked/songs/' + songName + '/audio/' + copyThese[i] + '.ogg', 'mods/songs/' + songName + '/' + copyThese[i] + '.ogg');
            }
        } else {
            for (i in 0...copyThese.length) {
                File.copy('assets/locked/songs/' + songName + '/audio/' + copyThese[i] + '.ogg', 'mods/songs/' + songName + '/' + copyThese[i] + '.ogg');
            }
        }
    }
    
    function setUnlockedContent(contentType:Int) {
        switch (contentType) {
            case 0:
            contentString = 'Character';
            case 1:
            contentString = 'Song';
            case 2:
            contentString = 'Noteskin';
        }
        trace(unlockedContent);
        // return unlockedContent;
        // displayResultMsg(0, contentType);
    }
    function prepMainCreate(i:Int) {
        new FlxTimer().start(3, function (tmr:FlxTimer) {
            if (i == sussyFlags.length) {
                /* if (hahaBosip != null) {
                    hahaBosip.destroy();
                }
                if (hahaBob != null) {
                    hahaBob.destroy();
                }
                if (hahaMiniShoey != null) {
                    hahaMiniShoey.destroy();
                } */
                if (hahaSaber != null) {
                    hahaSaber.destroy();
                }
                if (hahaBfOp != null) {
                    hahaBfOp.destroy();
                }
                /* if (ohnoBosip != null) {
                    ohnoBosip.destroy();
                }
                if (ohnoBob != null) {
                    ohnoBob.destroy();
                }
                if (ohnoMiniShoey != null) {
                    ohnoMiniShoey.destroy();
                } */
                if (ohnoSaber != null) {
                    ohnoSaber.destroy();
                }
                if (ohnoBfOp != null) {
                    ohnoBfOp.destroy();
                }
                sussyText.destroy();
                sussyBg.destroy();
                finishedCheck = true;
                trueCreate();
            }
        });
    }

    function displayResultMsg(suspiciousResultCode:Int, fuckYouHaxe:Int, ?unlockedContent:Array<Dynamic>) {
        var errorBg:FlxSprite = new FlxSprite(0).makeGraphic(1280, 720, FlxColor.RED);
        errorBg.alpha = 0.3;
        errorBg.visible = false;
        errorBg.screenCenter();
        add(errorBg);
        trace(unlockedContent);
        /* switch (fuckYouHaxe) {
            case 0:
                useInstructions.push('To use this new character, go into the chart editor. Your new character will be in the character list as ' + unlockedContent[5]);
            case 1:
                useInstructions.push("To play the new song, check the Freeplay menu. If it's not there, its name is " + unlockedContent[2] + " and you can add it to a new week.");
            case 2:
                useInstructions.push("To set this noteskin, go into the chart editor. In the 'Song' section, type 'funnyNotes/" + unlockedContent[5] + "' in the note skin box and click reload notes.");
            case 3:
                trace('this is a very large oof');
        } */
        switch (suspiciousResultCode) {
            case 0:
                trace('done');
                errorBg.color = FlxColor.GREEN;
                errorBg.visible = true;
                var errorTxt:FlxText = new FlxText(0, 0, FlxG.width, 'You have unlocked the ' + unlockedContent[1] + ', which is a ' + unlockedContent[0] + ' ' + unlockedContent[3] + ': ' + unlockedContent[2] + ', enjoy!\nThe password you used to unlock this can not be used anymore.', 48);
                errorTxt.setFormat(Paths.font('funny.ttf'), 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                errorTxt.screenCenter(Y);
                add(errorTxt);
                new FlxTimer().start(3, function (tmr:FlxTimer) {
                    errorTxt.destroy();
                    errorBg.visible = false;
                });
            case 1:
                trace('invalid pw');
                if (errorBg.color != FlxColor.RED) errorBg.color = FlxColor.RED;
                errorBg.visible = true;
                var errorTxt:FlxText = new FlxText(0, 0, FlxG.width, 'Invalid password. Please make sure you have entered the password correctly.\nPasswords ARE case sensitive!', 48);
                errorTxt.setFormat(Paths.font('funny.ttf'), 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                errorTxt.screenCenter(Y);
                add(errorTxt);
                new FlxTimer().start(3, function (tmr:FlxTimer) {
                    errorTxt.destroy();
                    errorBg.visible = false;
                });
            case 2: 
                trace('already used');
                errorBg.color = FlxColor.YELLOW;
                errorBg.visible = true;
                var errorTxt:FlxText = new FlxText(0, 0, FlxG.width, 'You have already used this password!', 48);
                errorTxt.setFormat(Paths.font('funny.ttf'), 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                errorTxt.screenCenter(Y);
                add(errorTxt);
                new FlxTimer().start(3, function (tmr:FlxTimer) {
                    errorTxt.destroy();
                    errorBg.visible = false;
                });
            case 3:
                trace('debug reset');
                errorBg.color = FlxColor.fromRGB(71, 117, 0);
                errorBg.visible = true;
                var errorTxt:FlxText = new FlxText(0, 0, FlxG.width, 'Debug flags reset.', 48);
                errorTxt.setFormat(Paths.font('funny.ttf'), 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                errorTxt.screenCenter(Y);
                add(errorTxt);
                new FlxTimer().start(3, function (tmr:FlxTimer) {
                    if (miniSaber.shader == null) {
                        miniSaber.shader = lockedShader.shader;
                    }
                    if (bfOpponent.shader == null) {
                        bfOpponent.shader = lockedShader.shader;
                    }
                    if (youIdiot.shader == null) {
                        youIdiot.shader = lockedShader.shader;
                    }
                    errorTxt.destroy();
                    errorBg.visible = false;
                });
        }
    }
}
class DebugPasswordShit extends MusicBeatSubstate {
    var enterPass:FlxUIInputText;
    var passPrompt:FlxText;
    var saveBg:FlxSprite;
    var promptBg:FlxSprite;
    var savingText:FlxText;
    var resetText:FlxText;
    var savePass:FlxButton;
    
    public function new() {
        super();
        promptBg = new FlxSprite(0).makeGraphic(1280, 720, FlxColor.fromRGB(128, 128, 0, 255));
        promptBg.screenCenter();
        promptBg.updateHitbox();
        enterPass = new FlxUIInputText(0, 0, 250, '', 24, FlxColor.RED, FlxColor.BLUE);
        enterPass.screenCenter();
        passPrompt = new FlxText(0, 0, FlxG.width, "This appears to be your first time opening this menu in debug mode. Please enter a password below to be able to reset your used passwords.");
        passPrompt.setFormat(Paths.font('funny.ttf'), 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.LIME);
        passPrompt.y = enterPass.y - 250;
        savePass = new FlxButton(0, enterPass.y + 50, 'Save Password', function() {
            saveBg = new FlxSprite(0).makeGraphic(1280, 720, FlxColor.fromRGB(0, 128, 128, 128));
            saveBg.screenCenter();
            saveBg.updateHitbox();
            add(saveBg);
            savingText = new FlxText(0, 0, FlxG.width);
            savingText.setFormat(Paths.font('funny.ttf'), 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
            savingText.text = "Saving password...";
            savingText.screenCenter();
            add(savingText);
            new FlxTimer().start(5, function (tmr:FlxTimer) {
                sys.io.File.saveContent('assets/data/JOEMAMA.TXT', enterPass.text);
                savingText.visible = false;
                resetText = new FlxText(0, 0, FlxG.width);
                resetText.setFormat(Paths.font('funny.ttf'), 48, FlxColor.LIME, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.MAGENTA);
                resetText.text = 'Your password has been saved. You will be returned to the main menu shortly.';
                add(resetText);
                new FlxTimer().start(3, function(tmr:FlxTimer) {
                    MusicBeatState.switchState(new MainMenuState());
                });
            });
        });
        savePass.screenCenter(X);
        add(promptBg);
        add(enterPass);
        add(passPrompt);
        add(savePass);
    }
}