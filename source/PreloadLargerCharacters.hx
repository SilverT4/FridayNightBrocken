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

    override function create() {
        /* camPreload = new FlxCamera();
        camPreload.bgColor.alpha = 0;
        FlxG.cameras.add(camPreload); */
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
            if (modChars[i].endsWith('.xml') || modChars[i].endsWith('.json')) {
                trace('xml/json skip');
            } else {
                trace('adding character ' + modChars[i].substr(modChars[i].length));
                preloadModChars.push(preloadDirs[1] + '/' + modChars[i]);
            }
        }
        beginPreloading(true);
        #else
        beginPreloading();
        #end

        
    }

    override function update(elapsed:Float) {
        if (speen != null) {
            speen.update(elapsed);
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
                for (i in 0...preloadBaseChars.length) {
                    loadingText.text = 'Now preloading ' + preloadBaseChars[i] + ' to improve load times';
                    new FlxTimer().start(1, function (tmr:FlxTimer) {
                        var f:FlxSprite = new FlxSprite();
                        f.loadGraphic(preloadBaseChars[i]);
                    });
                }
            });
        });
    }
}