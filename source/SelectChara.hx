package;

import flixel.ui.FlxButton;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxExtendedSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;

#if sys
import sys.FileSystem;
#end

using StringTools;
/**
    Let's get a typedef for character things.
    @param friendlyName The friendly name of your character. As an example, bf is Boyfriend.
    @param characterName The name of your character on the json file. You pick this in the chart editor.
    @param hasHey Does your character have a hey animation?
    @param heyName The name of your character's hey animation.*/
typedef CharSelShit = {
    var friendlyName:String;
    var characterName:String;
    var hasHey:Bool;
    var heyName:String;
}
/**
    This is a character selection screen. You can add a character from the editor. BF and his base-game variants are already here!
    */
class SelectChara extends MusicBeatState {
    /**
        Base game songs will have a background here. I'm planning to add support for custom backgrounds for mod songs.
        Those would work by placing a screenshot of your song in play in the images folder.*/
    var songBg:FlxSprite;
    /** 
        BF. What more can I say. As you navigate the menu, this'll be updated.*/
    var daBoyf:Character;
    /**
        What background are we using for the menu? This variable determines that.*/
    var bgToUse:String = 'menuDesat';
    /**
        This sprite is the BACK button on-screen. When clicked, you return to the freeplay menu or story menu.*/
    var backButton:FlxExtendedSprite;
    /**
        i want a separate camera for the UI just in case. lmao*/
    var camButtons:FlxCamera;
    /**
        The character's name. For BF, it's just Boyfriend.*/
    var charFriendlyName:String = 'Boyfriend';
    /**temp*/
    var leftButton:FlxButton;
    /**temp*/
    var rightButton:FlxButton;
    /**temp*/
    var startButton:FlxButton;
    /**This variable will contain the base game bf variations by default. A function called after checkSong will add mod characters*/
    var bfVariations:Array<String> = ['bf', 'bf-car', 'bf-christmas', 'bf-pixel'];
    /**
        bf override for playstate in story mode*/
    public var bfOverride:String;

    public function new() {
        super();
        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
            #if debug
            FlxG.mouse.useSystemCursor = true;
            #end
        }
        trace('check SONG');
        camButtons = new FlxCamera();
        camButtons.bgColor.alpha = 0;
        FlxG.cameras.add(camButtons);
        trace(FlxG.cameras.list);
        checkSong();
    }

    function checkSong() {
        trace('crash prevention go');
        if (PlayState.SONG == null) {
            PlayState.SONG = Song.loadFromJson('test', 'test');
        }
        if (!FileSystem.exists('assets/images/songback/' + PlayState.SONG.song.toLowerCase() + '.png')) {
            trace('must not be base game');
            if (!FileSystem.exists(Paths.modsImages('songback/' + PlayState.SONG.song.toLowerCase()))) {
                trace('lets use default menu bg');
                bgToUse = Paths.image('menuDesat');
            } else {
                trace('sus');
                bgToUse = Paths.modsImages('songback/' + PlayState.SONG.song.toLowerCase());
            }
        } else {
            bgToUse = Paths.image('songback/' + PlayState.SONG.song.toLowerCase());
        } 
        createDaUI();
    }
    /**this'll be called after checksong finishes*/
    function createDaUI() {
        songBg = new FlxSprite();
        songBg.loadGraphic(bgToUse);
        if (bgToUse == Paths.image('menuDesat')) {
            songBg.color = 0xFFA6D388;
        }
        songBg.scrollFactor.set();
        songBg.screenCenter();
        add(songBg);
        daBoyf = new Character(0, 0, PlayState.SONG.player1);
        daBoyf.flipX = true;
        daBoyf.screenCenter();
        add(daBoyf);
        leftButton = new FlxButton(150, FlxG.height - 200, '<');
        leftButton.color = FlxColor.BLUE;
        leftButton.label.color = FlxColor.BLACK;
        leftButton.cameras = [camButtons];
        add(leftButton);
    }

    inline function updateBoyfriend(?change:Int = 0) {
        trace('sus');
    }

    override function update(elapsed:Float) {
        if (controls.BACK) {
            MusicBeatState.switchState(new MainMenuState());
        }
        if (daBoyf != null) {
            daBoyf.update(elapsed);
            if (daBoyf.animation.curAnim.finished) {
                daBoyf.dance();
            }
        }
    }
}