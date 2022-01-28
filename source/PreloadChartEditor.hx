package;

import haxe.Json;
import Character.CharacterFile;
import ClientPrefs;
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
import sys.FileStat;
import sys.FileSystem;
#end

using StringTools;

class PreloadChartEditor extends FlxState {
    var loadingText:FlxText;
    var loadingBg:FlxSprite;
    var preloadDirs:Array<String> = ['assets/images', #if MODS_ALLOWED 'mods/images/funnyNotes' #end];
    var speen:FlxSprite;
    var textBox:FlxSprite;
    var susSong:String = 'bussy-sharts';
    var sussySong:Song.SwagSong;
    var wet:Bool = false;
    var loadShader:ColorSwap;

    public function new(?songName:String, ?enteringFromMEM:Bool) {
        super();
        if (songName != null) {
            susSong = songName;
        } else {
            trace('my bussy has sharted');
        }
        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
            FlxG.mouse.useSystemCursor = true;
        }
    }

    override function update(elapsed:Float) {
        if (speen != null) {
            speen.update(elapsed);
        }
    }

    override function create() {
        loadShader = new ColorSwap();
        loadShader.hue = 69;
        loadShader.saturation += 100;
        loadingBg = new FlxSprite(0).loadGraphic('assets/images/editor/chartingPreloaderBg.png');
        loadingBg.shader = loadShader.shader;
        // loadingBg.alpha = 0.5;
        add(loadingBg);
        trace('vagina');
        textBox = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 20, FlxColor.BLACK);
        textBox.alpha = 0.6;
        textBox.scrollFactor.set();
        add(textBox);
        loadingText = new FlxText(textBox.x, textBox.y + 4, FlxG.width);
        loadingText.text = 'Preparing to preload note assets...';
        add(loadingText);
        speen = new FlxSprite(FlxG.width - 48, FlxG.height - 48);
        speen.frames = FlxAtlasFrames.fromSparrow('assets/images/editor/speen.png', 'assets/images/editor/speen.xml');
        speen.animation.addByPrefix('spin', 'spinner go brr', 30, true);
        speen.animation.play('spin');
        add(speen);
    }
}