package;

import editors.ChartingState;
import editors.ChartingState.AttachedFlxText;
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
        
        loadingText.text = 'Now preloading note assets';
        var preloadedNotes:Array<String> = ['assets/images/NOTE_assets', 'assets/images/HURTNOTE_assets'];
        var modNotes:Array<Dynamic> = [];
        var modNotesList = FileSystem.readDirectory(Paths.modFolders('images/funnyNotes'));
        #if MODS_ALLOWED
        if (FileSystem.exists('mods/images/funnyNotes')) {
            for (i in 0...modNotesList.length) {
                if (modNotesList[i].endsWith('.xml')) {
                    trace('skip');
                } else {
                    modNotes.push(modNotesList[i]);
                }
            }
        } else {
            trace('skipping mod notes');
            loadingText.text = 'Now preloading note assets (skipping mod notes)';
        }
        #end
        var curNotes:Int = 0;
        new FlxTimer().start(3, function (tmr:FlxTimer) {
            loadingText.text = 'Now preloading base game note asset ' + Std.int(curNotes + 1) + ' of ' + preloadedNotes.length + ': ' + preloadedNotes[curNotes];
            var f:FlxSprite = new FlxSprite();
            f.loadGraphic(preloadedNotes[curNotes] + '.png');
            f.destroy();
            curNotes += 1;
            if (curNotes >= preloadedNotes.length) {
                #if MODS_ALLOWED
                if (modNotes != null) {
                    loadingText.text = 'Getting ready to load mod notes...';
                    curNotes = 0;
                    new FlxTimer().start(3, function (tmr:FlxTimer) {
                        loadingText.text = 'Now preloading mod note asset ' + Std.int(curNotes + 1) + ' of ' + modNotes.length + ': ' + modNotes[curNotes];
                        var l:FlxSprite = new FlxSprite();
                        l.loadGraphic(Paths.modFolders('images/funnyNotes/' + modNotes[curNotes]));
                        l.destroy();
                        curNotes += 1;
                        if (curNotes >= modNotes.length) {
                            FlxG.sound.play(Paths.sound('lookingSpiffy'));
                            exitPreloader();
                        }
                    }, modNotes.length);
                } else {
                    exitPreloader();
                }
                #else
                exitPreloader();
                #end
            }
        }, preloadedNotes.length);
    }

    function exitPreloader() {
        new FlxTimer().start(3, function (tmr:FlxTimer) {
            if (loadingText != null) loadingText.text = 'Done preloading!';
            var hahaha:FlxSound = new FlxSound();
            hahaha.loadEmbedded('assets/sounds/phaseComplete.ogg');
            FlxG.mouse.useSystemCursor = false;
            hahaha.play();
            if (PlayState.SONG == null) PlayState.SONG = Song.loadFromJson(susSong, susSong.toLowerCase());
            new FlxTimer().start(hahaha.length / 1000, function (tmr:FlxTimer) {
                FlxG.cameras.fade(FlxColor.BLACK, 1.5, false, function() {
                    FlxG.switchState(new ChartingState());
                });
            });
        });
    }
}