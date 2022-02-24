package;

import flixel.addons.ui.FlxUITabMenu;
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
import Boyfriend as Bruhfriend;

#if sys
import sys.FileSystem;
import sys.FileStat;
#end

using StringTools;
/**
    Let's get a typedef for character things.
    @param friendlyName The friendly name of your character. As an example, bf is Boyfriend.
    @param characterName The name of your character on the json file. You pick this in the chart editor.
    @param hasHey Does your character have a hey animation?
    @param heyName The name of your character's hey animation.
    @param deathCharacter If this is a variation, put the normal character here.*/
typedef CharSelShit = {
    var friendlyName:String;
    var characterName:String;
    var hasHey:Bool;
    var heyName:String;
    var deathCharacter:String;
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
    public var daBoyf:Character;
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
    /**
        this gets set with updatebf if available*/
    var charShit:CharSelShit;
    /**displays friendly name*/
    var fnameDisplay:FlxText;
    var loadNotice:FlxText;
    var timeElapse:FlxText;

    public function new() {
        super();
        instance = this;
        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
            #if debug
            FlxG.mouse.useSystemCursor = true;
            #end
        }
        if (!FlxG.sound.music.playing) {
            FlxG.sound.playMusic(Paths.music('mktFriends', 'shared'));
        }
        trace('check SONG');
        camButtons = new FlxCamera();
        camButtons.bgColor.alpha = 0;
        FlxG.cameras.add(camButtons);
        add(camButtons);
        trace(FlxG.cameras.list);
        charShit = cast Json.parse(SelectableCreatorState.defaults);
        loadNotice = new FlxText(0, 0, FlxG.width, 'If you see this for more than 30 seconds, press ESCAPE to exit the menu!');
        loadNotice.setFormat(Paths.font('funny.ttf'), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        loadNotice.screenCenter();
        add(loadNotice);
        /*timeElapse = new FlxText(0, FlxG.height - 24, FlxG.width, null, 24);
        timeElapse.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.GREEN);
        add(timeElapse);*/
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
        addMoreBoyfriends();
    }
    /**adds player characters in mods/selectable*/
    function addMoreBoyfriends() {
        trace('amogus');
        if (FileSystem.exists('mods/selectable')) {
            var path:String = 'mods/selectable';
            var shit:Array<String> = [];
            var jsons:Array<String> = FileSystem.readDirectory('mods/selectable');
            for (i in 0...jsons.length) {
                checkEntry(jsons[i]);
                loadNotice.text = 'Press SPACE to continue';
            }
        }
    }
    inline function checkEntry(input:String) {
        if (input.endsWith('.txt')) {
            trace('skip this');
        } else {
            trace(input.substring(0, Std.int(input.length - 5)));
            bfVariations.push(input.substring(0, Std.int(input.length - 5)));
            trace(bfVariations);
            FlxG.log.notice(bfVariations);
        }
    }
    /**this'll be called after checksong finishes*/
    function createDaUI() {
        loadNotice.kill();
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
        leftButton = new FlxButton(150, FlxG.height - 100, '<-', function() {
            updateBoyfriend(-1);
        });
        leftButton.color = FlxColor.BLUE;
        leftButton.label.color = FlxColor.BLACK;
        // leftButton.cameras = [camButtons];
        add(leftButton);
        startButton = new FlxButton(0, FlxG.height - 100, 'START', function() {
            beginSong(daBoyf.curCharacter);
        });
        startButton.color = FlxColor.LIME;
        startButton.label.color = FlxColor.WHITE;
        startButton.setGraphicSize(Std.int(startButton.width * 3));
        startButton.label.setFormat(null, 48);
        startButton.label.fieldWidth *= 3;
        startButton.updateHitbox();
        startButton.screenCenter(X);
        add(startButton);
        rightButton = new FlxButton(FlxG.width - 250, FlxG.height - 100, '->', function() {
            updateBoyfriend(1);
        });
        rightButton.color = FlxColor.BLUE;
        rightButton.label.color = FlxColor.BLACK;
        // rightButton.cameras = [camButtons];
        add(rightButton);
        fnameDisplay = new FlxText(0, 20, FlxG.width, 'Boyfriend', 64);
        fnameDisplay.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(fnameDisplay);
    }
    /**Starts the song. How much more simply would I need to explain that?*/
    inline function beginSong(character:String = 'bf') {
        trace('STOP TALKING ABOUT AMONG US');
        FlxG.sound.music.stop();
        FlxG.sound.playMusic(Paths.music('gameOverEnd', 'shared'));
        PlayState.SONG.player1 = character;
        bfOverride = character;
        LoadingState.loadAndSwitchState(new PlayState());
    }
    /**used for updatebf*/
    var chump:Int = 0;
    /**Updates the bf on screen.*/
    inline function updateBoyfriend(?change:Int = 0) {
        trace('sus');
        chump += change;
        if (chump < 0) {
            chump = bfVariations.length - 1;
        } else if (chump > bfVariations.length) {
            chump = 0;
        }
        daBoyf.destroy();
        daBoyf = new Character(0, 0, bfVariations[chump]);
        daBoyf.flipX = true;
        daBoyf.screenCenter();
        add(daBoyf);
        if (FileSystem.exists(Paths.modsSelectable(daBoyf.curCharacter))) {
            var bullshit = cast Json.parse(sys.io.File.getContent(Paths.modsSelectable(daBoyf.curCharacter)));
            trace(bullshit);
            charShit.characterName = bullshit.characterName;
            charShit.deathCharacter = bullshit.deathCharacter;
            charShit.friendlyName = bullshit.friendlyName;
            charShit.hasHey = bullshit.hasHey;
            charShit.heyName = bullshit.heyName;
        }
    }
    public var susOver:Bool = false;
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
        if (leftButton != null && leftButton.isOnScreen()) {
            leftButton.update(elapsed);
        }

        if (startButton != null && startButton.isOnScreen()) {
            startButton.update(elapsed);
        }

        if (rightButton != null && rightButton.isOnScreen()) {
            rightButton.update(elapsed);
        }
        
        if (fnameDisplay != null) {
            fnameDisplay.update(elapsed);
            if (fnameDisplay.text != charShit.friendlyName) {
                fnameDisplay.text = charShit.friendlyName;
            }
        }
        if (timeElapse != null) {
            timeElapse.update(elapsed);
            timeElapse.text = Std.string(elapsed);
        }
        if (loadNotice != null) {
            loadNotice.update(elapsed);
        }
        if (FlxG.keys.justPressed.SPACE && loadNotice.text == 'Press SPACE to continue' && loadNotice != null) {
            createDaUI();
        }

        if (FlxG.keys.justPressed.L && !susOver) {
            daBoyf.kill();
            susOver = true;
            openSubState(new GameOverPreview(daBoyf.getGraphicMidpoint().x, daBoyf.getGraphicMidpoint().y, daBoyf.curCharacter)); //daBoyf.curCharacter is a placeholder until I set up the actual selectable shit!
        }

        if (daBoyf != null && FlxG.keys.justPressed.E) {
            trace('editing ' + daBoyf.curCharacter);

        }
    }

    public static var instance:SelectChara;
}

/**
    I'll move this to its own file later. ANYWAY.
    This state allows you to create a selectable JSON.*/
class SelectableCreatorState extends MusicBeatState {
    /**Template*/
    public static var defaults:String = '{
        "friendlyName": "Boyfriend",
        "characterName": "bf",
        "hasHey": true,
        "heyName": "hey",
        "deathCharacter": "bf"
    }';
    /**friendly name*/
    var friendlyName:String;
    /**character name*/
    var characterName:String;
    /**has hey?*/
    var hasHey:Bool;
    /**hey name*/
    var heyName:String;
    /**death chara*/
    var deathCharacter:String;
    /**The main UI box. This'll contain all the settings.*/
    var UI_shit:FlxUITabMenu;
    /**Camera for the UI elements.*/
    var camBruh:FlxCamera;
    
    public function new(?chara:String = 'snowcon') {
        super();
        if (chara != null) characterName = chara;
    }

}
/**
    bruh*/
class Bruh {
    var moment:String = 'bruh';
}
/**A preview of the gameover substate for the selectable editor because yes.*/
class GameOverPreview extends MusicBeatSubstate {
    static inline final SHARED = 'shared';

    /**character name, defaults to bf*/
    var charName:String = 'bf';
    /**gameover music*/
    var gameOverMusic:String = 'gameOver-bnb';
    /**end sound*/
    var gameOverEndingSound:String = 'gameOverEnd-bnb';
    /**bruh*/
    var bruh:Bruh;
    /**bf for sake of SHITPOST /j*/
    var bruhFriend:Bruhfriend;
    /**so we can follow bf like real game over*/
    var camFollow:FlxPoint;
    /**same as camFollow*/
    var camFollowPos:FlxObject;
    /**mic drops*/
    var deathSoundName:String = 'fnf_loss_sfx';
    /**update cam thing idk*/
    var updateCamera:Bool = false;
    override function create() {
        super.create();
    }
    public function new(x:Float, y:Float, ?charName:String = 'bf', ?overMusic:String = 'gameOver-bnb', ?endSound:String = 'gameOverEnd-bnb') {
        super();
        var fuckme:FlxSprite = new FlxSprite(x - 1000, y - 1000).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
        add(fuckme);
        bruhFriend = new Bruhfriend(x, y, charName);
        bruhFriend.x += bruhFriend.positionArray[0];
        bruhFriend.y += bruhFriend.positionArray[1];
        add(bruhFriend);

        camFollow = new FlxPoint(bruhFriend.getGraphicMidpoint().x, bruhFriend.getGraphicMidpoint().y);
        if (overMusic != null && endSound != null) {
            gameOverMusic = overMusic;
            gameOverEndingSound = endSound;
        }
        FlxG.sound.music.stop();
        FlxG.sound.play(Paths.sound(deathSoundName, SHARED));
		Conductor.changeBPM(100);
		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

        bruhFriend.playAnim('firstDeath');

        camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		add(camFollowPos);
    }
    var isEnding:Bool = false;
    var isFollowingAlready:Bool = false;
    override function update(elapsed:Float) {
        super.update(elapsed);
        if(updateCamera) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 0.6, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}
        if (bruhFriend != null) {
            bruhFriend.update(elapsed);
        }
        if (controls.ACCEPT)
            {
                endBullshit();
            }
            if (bruhFriend.animation.curAnim.name == 'firstDeath')
                {
                    if(bruhFriend.animation.curAnim.curFrame >= 12 && !isFollowingAlready)
                    {
                        FlxG.camera.follow(camFollowPos, LOCKON, 1);
                        updateCamera = true;
                        isFollowingAlready = true;
                    }
        
                    if (bruhFriend.animation.curAnim.finished)
                    {
                        coolStartDeath();
                        bruhFriend.startedDeath = true;
                    }
                }
                if (FlxG.sound.music.playing)
                    {
                        Conductor.songPosition = FlxG.sound.music.time;
                    }
    }
    override function beatHit()
        {
            super.beatHit();
    
            //FlxG.log.add('beat');
        }
    function endBullshit() {
        if (!isEnding)
            {
                isEnding = true;
                trace(SelectChara.instance.susOver);
                if (!SelectChara.instance.daBoyf.alive) {
                    SelectChara.instance.daBoyf.revive();
                    camFollow.x = SelectChara.instance.daBoyf.getGraphicMidpoint().x;
                    camFollow.y = SelectChara.instance.daBoyf.getGraphicMidpoint().y;
                }
                bruhFriend.playAnim('deathConfirm', true);
                FlxG.sound.music.stop();
                FlxG.sound.play(Paths.music(gameOverEndingSound, SHARED));
                new FlxTimer().start(0.7, function(tmr:FlxTimer)
                    {
                        FlxG.camera.fade(FlxColor.BLACK, 3, false, function()
                        {
                            FlxG.camera.stopFX();
                            close();
                        });
                    });
                }
            
    }

	function coolStartDeath() {
        FlxG.sound.playMusic(Paths.music(gameOverMusic, SHARED));
    }
}