package;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import spritesheet.AnimatedSprite;
import spritesheet.data.SpritesheetFrame;
import openfl.display.DisplayObjectContainer;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import spritesheet.Spritesheet;
import openfl.events.Event;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class PreloadLargerCharacters extends FlxState {
    var preloadDirs:Array<String> = ['assets/shared/images/characters'#if MODS_ALLOWED , 'mods/images/characters' #end];
    var baseChars:Array<String>;
    var modChars:Array<String>;
    var preloadBaseChars:Array<Dynamic> = [];
    var preloadModChars:Array<Dynamic> = [];
    var speener:Spritesheet;
    var speen:FlxSprite;
    var camPreload:FlxCamera;
    var textBox:FlxSprite;
    var loadingText:FlxText;
    var skippablePreload:Bool = true;
    
    override function create() {
        /* camPreload = new FlxCamera();
        camPreload.bgColor.alpha = 0;
        FlxG.cameras.add(camPreload); */
        if (!FlxG.mouse.useSystemCursor) {
            FlxG.mouse.useSystemCursor = true;
        }
        speen = new FlxSprite(FlxG.width - 48, FlxG.height - 48);
        speen.frames = FlxAtlasFrames.fromSparrow('assets/images/editor/speen.png', 'assets/images/editor/speen.xml');
        speen.animation.addByPrefix('spin', 'spinner go brr', 30, true);
        speen.animation.play('spin');
        // speen.cameras = [camPreload];
        baseChars = FileSystem.readDirectory(preloadDirs[0]);
        trace('preloading larger characters');
        for (i in 0...baseChars.length) {
            if (baseChars[i].endsWith('.xml') || baseChars[i].endsWith('.txt')) {
                trace('xml skip');
            } else {
                trace('adding character ' + baseChars[i].substr(baseChars[i].length));
                preloadBaseChars.push(preloadDirs[0] + '/' + baseChars[i]);
            }
        }
        #if MODS_ALLOWED
        modChars = FileSystem.readDirectory(preloadDirs[1]);
        for (i in 0...modChars.length) {
            if (modChars[i].endsWith('.xml') || modChars[i].endsWith('.json') || modChars[i].endsWith('.txt')) {
                trace('xml/json skip');
            } else {
                trace('adding character ' + modChars[i].substr(modChars[i].length));
                preloadModChars.push(preloadDirs[1] + '/' + modChars[i]);
            }
        }
        var funText:FlxText = new FlxText(0, 0, FlxG.width, 'Press any key to skip preloading...');
        funText.setFormat(Paths.font('vcr.ttf'), 48, FlxColor.WHITE, CENTER);
        funText.screenCenter();
        add(funText);
        new FlxTimer().start(5, function (tmr:FlxTimer) {
            skippablePreload = false;
            funText.destroy();
            beginPreloading(true);
        });
        #else
        var funText:FlxText = new FlxText(0, 0, FlxG.width, 'Press any key to skip preloading...');
        funText.setFormat(Paths.font('vcr.ttf'), 48, FlxColor.WHITE, CENTER);
        funText.screenCenter();
        add(funText);
        new FlxTimer().start(5, function (tmr:FlxTimer) {
            funText.destroy();
            skippablePreload = false;
            beginPreloading();
        });
        #end
        
        
    }
    
    override function update(elapsed:Float) {
        if (speen != null) {
            speen.update(elapsed);
        }

        if (FlxG.keys.justReleased.ANY && skippablePreload) {
            exitPreloader();
        }
    }
    
    function beginPreloading(?modsEnabled:Bool) {
        if (modsEnabled == null) modsEnabled = false; //ASSUME FALSE IF UNSPECIFIED ON CALL
        textBox = new FlxSprite(0, FlxG.height - 26);
        textBox.makeGraphic(FlxG.width, 26, FlxColor.fromRGB(16, 16, 16));
        // textBox.color = FlxColor.fromRGB(16, 16, 16);
        textBox.alpha = 0.6;
        textBox.scrollFactor.set();
        // textBox.screenCenter(Y);
        add(textBox);
        add(speen);
        loadingText = new FlxText(textBox.x, textBox.y + 4, FlxG.width, 'Preparing to preload graphics...', 16);
        add(loadingText);
        // loadingText.text = 'test';
        new FlxTimer().start(3, function (tmr:FlxTimer) {
            loadingText.text = 'Getting ready to preload character graphics in assets/shared...';
            new FlxTimer().start(3, function (tmr:FlxTimer) {
                var curChar:Int = 0;
                new FlxTimer().start(1.5, function (tmr:FlxTimer) {
                    loadingText.text = 'Now preloading ' + preloadBaseChars[curChar] + ' to improve load times';
                    var f:FlxSprite = new FlxSprite();
                    f.loadGraphic(preloadBaseChars[curChar]);
                    f.kill();
                    curChar += 1;
                    if (curChar >= preloadBaseChars.length && preloadModChars.length == 0) exitPreloader();
                }, preloadBaseChars.length);
            });
        });
        #if MODS_ALLOWED
        if (modsEnabled) {
        new FlxTimer().start(5, function(tmr:FlxTimer) {
            loadingText.text = 'Now preparing to preload mod characters. This will only preload from mods/images';
            new FlxTimer().start(3, function (tmr:FlxTimer) {
                var curChar:Int = 0;
                new FlxTimer().start(1, function (tmr:FlxTimer) {
                    loadingText.text = 'Now preloading ' + preloadModChars[curChar] + ' to improve load times';
                    var f:FlxSprite = new FlxSprite();
                    f.loadGraphic(preloadModChars[curChar]);
                    f.kill();
                    curChar += 1;
                    if (curChar >= preloadModChars.length) exitPreloader();
                }, preloadModChars.length);
            });
        });
        }
        #end
    }
    
    function exitPreloader() {
        new FlxTimer().start(3, function(tmr:FlxTimer) {
            loadingText.text = 'Done preloading!';
            var huhhhhhh:FlxSound = new FlxSound();
            huhhhhhh.loadEmbedded(Paths.sound('phaseComplete'));
            FlxG.mouse.useSystemCursor = true;
            huhhhhhh.play();
            new FlxTimer().start(huhhhhhh.length / 1000, function (tmr:FlxTimer) {
                MusicBeatState.switchState(new TitleState());
            });
        });
    }
}