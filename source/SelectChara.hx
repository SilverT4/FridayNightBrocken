package;

import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
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
import Character.CharacterFile;

#if sys
import sys.FileSystem;
import sys.FileStat;
#end

using StringTools;
/**hey there, you're lookin like a certified bussy shart today.
    so i just want to mention one thing about this hx file in particular.
    the code is VERY MUCH spaghetti code. i'm not good at organising code or any of that shit, so it's gonna be spaghetti for as long as this repo exists really
    admittedly that may be *forever* lmao
    ANYWAY! if you want to improve this at all feel free to make adjustments and make a pull request.
    if you want to use this in your own repo, **give me credit** for it. you can leave a link to my github in the readme of your repo and/or just leave [this link](https://github.com/devin503) in this file.
    @since I first created this file. Please, give me credit if you want to use this in your own repo!*/
typedef Amogus = {
    var readthenote:Bruh;
}
        /**
    Let's get a typedef for character things.
    @param friendlyName The friendly name of your character. As an example, bf is Boyfriend.
    @param characterName The name of your character on the json file. You pick this in the chart editor.
    @param hasHey Does your character have a hey animation?
    @param heyName The name of your character's hey animation.
    @param deathCharacter If this is a variation, put the normal character here.
    @since February 2022 (Emo Engine 0.1.1)*/
typedef CharSelShit = {
    var friendlyName:String;
    var characterName:String;
    var hasHey:Bool;
    var heyName:String;
    var deathCharacter:String;
}
/**
    This is a character selection screen. You can add a character from the editor. BF and his base-game variants are already here!
    @since February 2022 (Emo Engine 0.1.1)*/
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
        The character's name. For BF, it's just Bruhfriend.*/
    var charFriendlyName:String = 'Bruhfriend';
    /**temp*/
    var leftButton:FlxButton;
    /**temp*/
    var rightButton:FlxButton;
    /**temp*/
    var startButton:FlxButton;
    /**This variable will contain the base game bf variations by default. A function called after checkSong will add mod characters*/
    var bfVariations:Array<String> = [];
    /**
        bf override for playstate in story mode*/
    public static var bfOverride:String;
    /**
        this gets set with updatebf if available*/
    var charShit:CharSelShit;
    /**displays friendly name*/
    var fnameDisplay:FlxText;
    /**if this is true, the game will check for a songBg and if none is found, display a notice on screen to tell the player how to create one.*/
    var isModSong:Bool = false;
    var loadNotice:FlxText;
    var timeElapse:FlxText;
    var joe:CharSelShit;
    /**just so i can get colours from gf if player2 is nobody*/
    var babaGrill:CharacterFile;
    /**get dad colours*/
    var daddyIssues:CharacterFile;
    var startingSong:Bool = false;
    /**player 1's gonna have a placeholder in the list.*/
    var songBfPlaceholder:CharSelShit;
    /**idk if thisll work*/
    var bfInfos:Array<CharSelShit> = [];
    /**This contains a list of base game songs. With each new **base game** week, I'll update it.*/
    var baseSongs:Array<String> = [
        'tutorial',
        'bopeebo',
        'fresh',
        'dad-battle',
        'spookeez',
        'south',
        'monster',
        'pico',
        'philly-nice',
        'blammed',
        'satin-panties',
        'milf',
        'high',
        'winter-horrorland',
        'eggnog',
        'cocoa',
        'senpai',
        'roses',
        'thorns',
        'test'
    ];

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
        joe = charShit;
        loadNotice = new FlxText(0, 0, FlxG.width, 'If you see this for more than 30 seconds, press ESCAPE to exit the menu!');
        loadNotice.setFormat(Paths.font('funny.ttf'), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        loadNotice.screenCenter();
        add(loadNotice);
        /*timeElapse = new FlxText(0, FlxG.height - 24, FlxG.width, null, 24);
        timeElapse.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.GREEN);
        add(timeElapse);*/
        checkSong();
        addBaseBfs();
    }
    /**this adds placeholders for base-game BF information if needed. if you have a custom json for any of the defaults, that'll be inserted in addmorebfs*/
    function addBaseBfs() {
        trace('adding bf');
        var bfDefault:String = '{
            "characterName": "bf",
            "friendlyName": "Boyfriend",
            "hasHey": true,
            "heyName": "hey",
            "deathCharacter": "bf"
        }';
        var bfCarDefault:String = '{
            "characterName": "bf-car",
            "friendlyName": "Boyfriend (Car)",
            "hasHey": false,
            "heyName": "bruh",
            "deathCharacter": "bf"
        }';
        var bfChristmasDefault:String = '{
            "characterName": "bf-christmas",
            "friendlyName": "Festive Boyfriend",
            "hasHey": true,
            "heyName": "hey",
            "deathCharacter": "bf"
        }';
        var bfPixelDefault:String = '{
            "characterName": "bf-pixel",
            "friendlyName": "Pixel Boyfriend",
            "hasHey": false,
            "heyName": "bruh",
            "deathCharacter": "bf-pixel-dead"
        }';
        var bfPlaceholder:CharSelShit = cast Json.parse(bfDefault);
        var bfCarPlaceholder:CharSelShit = cast Json.parse(bfCarDefault);
        var bfChristmasPlaceholder:CharSelShit = cast Json.parse(bfChristmasDefault);
        var bfPixelPlaceholder:CharSelShit = cast Json.parse(bfPixelDefault);
        if (!FileSystem.exists(Paths.modsSelectable('bf'))) {
            bfInfos.push(bfPlaceholder);
            bfVariations.push('bf');
        }
        if (!FileSystem.exists(Paths.modsSelectable('bf-car'))) {
            bfInfos.push(bfCarPlaceholder);
            bfVariations.push('bf-car');
        } 
        if (!FileSystem.exists(Paths.modsSelectable('bf-christmas'))) {
            bfInfos.push(bfChristmasPlaceholder);
            bfVariations.push('bf-christmas');
        }
        if (!FileSystem.exists(Paths.modsSelectable('bf-pixel'))) {
            bfInfos.push(bfPixelPlaceholder);
            bfVariations.push('bf-pixel');
        }
        trace('added placeholders');
        trace(bfInfos);
    }
    function checkSong() {
        trace('crash prevention go');
        if (PlayState.SONG == null) {
            PlayState.SONG = Song.loadFromJson('test', 'test');
        }
        if (!FileSystem.exists('assets/images/songBack/' + PlayState.SONG.song.toLowerCase() + '.png')) {
            trace('must not be base game');
            if (!FileSystem.exists(Paths.modsImages('songBack/' + PlayState.SONG.song.toLowerCase()))) {
                trace('lets use default menu bg');
                bgToUse = Paths.image('menuDesat');
            } else {
                trace('sus');
                bgToUse = Paths.modsImages('songBack/' + PlayState.SONG.song.toLowerCase());
            }
        } else {
            bgToUse = Paths.image('songBack/' + PlayState.SONG.song.toLowerCase());
        }
        if (!baseSongs.contains(PlayState.SONG.song.toLowerCase())) isModSong = true;
        addMoreBruhfriends();
        getHealthColours();
    }
    /**get the health colours*/
    inline function getHealthColours() {
        var feet:String;
        if (PlayState.SONG.player2 == 'nobody') {
            if (PlayState.SONG.player3 != null) feet = PlayState.SONG.player3 else feet = PlayState.SONG.gfVersion;
        } else {
            feet = PlayState.SONG.player2;
        }
        var semen = cast Json.parse(sys.io.File.getContent(Paths.characterJson(feet)));
        if (feet == PlayState.SONG.player3 || feet == PlayState.SONG.gfVersion) {
            babaGrill = semen;
        } else {
            daddyIssues = semen;
        }
    }
    /**adds player characters in mods/selectable*/
    function addMoreBruhfriends() {
        trace('amogus');
        if (FileSystem.exists('mods/selectable')) {
            var path:String = 'mods/selectable';
            var shit:Array<String> = [];
            var jsons:Array<String> = FileSystem.readDirectory('mods/selectable');
            for (i in 0...jsons.length) {
                checkEntry(jsons[i]);
                if (i == jsons.length - 1) loadNotice.text = 'Press SPACE to continue';
            }
        }
        var songInfo:String = '
        {
            "characterName": "' + PlayState.SONG.player1 + '",
            "friendlyName": "Song\'s BF",
            "hasHey": false,
            "heyName": "hey",
            "deathCharacter": "' + PlayState.SONG.player1 + '"
        }';
        trace(songInfo);
        songBfPlaceholder = cast Json.parse(songInfo);
        bfVariations.insert(0, PlayState.SONG.player1);
    }
    inline function checkEntry(input:String) {
        if (input.endsWith('.txt')) {
            trace('skip this');
        } else {
            trace(input.substring(0, Std.int(input.length - 5)));
            if (input != 'bf-car.json') bfVariations.push(input.substring(0, Std.int(input.length - 5)));
            var bfVar:CharSelShit = cast Json.parse(sys.io.File.getContent(Paths.modsSelectable(input.substring(0, Std.int(input.length - 5)))));
            /*for (penis in bfVariations) {
                if (input == penis) {
                    switch (penis) {
                        case 'bf':
                            bfInfos.insert(0, bfVar);
                        case 'bf-car':
                            bfInfos.insert(1, bfVar);
                        case 'bf-christmas':
                            bfInfos.insert(2, bfVar);
                        case 'bf-pixel':
                            bfInfos.insert(3, bfVar);
                    }
                } else { */
                    bfInfos.push(bfVar);
                /*}
            }*/
            trace(bfVariations);
        }
    }
    /**this'll be called after checksong finishes*/
    function createDaUI() {
        loadNotice.kill();
        FlxG.sound.playMusic(Paths.music('mktFriends'));
        songBg = new FlxSprite();
        songBg.loadGraphic(bgToUse);
        /* if (bgToUse == Paths.image('menuDesat')) {
            songBg.color = 0xFFA6D388;
        } */
        if (PlayState.SONG.player2 == 'nobody') {
            songBg.color = FlxColor.fromRGB(babaGrill.healthbar_colors[0], babaGrill.healthbar_colors[1], babaGrill.healthbar_colors[2]);
        } else {
            songBg.color = FlxColor.fromRGB(daddyIssues.healthbar_colors[0], daddyIssues.healthbar_colors[1], daddyIssues.healthbar_colors[2]);
        }
        songBg.scrollFactor.set();
        songBg.screenCenter();
        add(songBg);
        var customBgNote:FlxText = new FlxText(0, FlxG.height - 24, FlxG.width, 'You can put your own background here! Press B to find out how.', 24);
        customBgNote.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.BLUE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
        if (bgToUse == Paths.image('menuDesat') && isModSong) add(customBgNote);
        daBoyf = new Character(0, 0, PlayState.SONG.player1);
        daBoyf.flipX = true;
        daBoyf.updateHitbox();
        daBoyf.screenCenter();
        add(daBoyf);
        leftButton = new FlxButton(150, FlxG.height - 100, '<-', function() {
            updateBruhfriend(-1);
        });
        leftButton.color = FlxColor.BLUE;
        leftButton.label.color = FlxColor.BLACK;
        // leftButton.cameras = [camButtons];
        add(leftButton);
        startButton = new FlxButton(0, FlxG.height - 100, 'START', function() {
            startingSong = true;
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
            updateBruhfriend(1);
        });
        rightButton.color = FlxColor.BLUE;
        rightButton.label.color = FlxColor.BLACK;
        // rightButton.cameras = [camButtons];
        add(rightButton);
        fnameDisplay = new FlxText(0, 20, FlxG.width, 'Bruhfriend', 64);
        fnameDisplay.setFormat(Paths.font('vcr.ttf'), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(fnameDisplay);
        backButton = new FlxExtendedSprite(0,0);
        backButton.frames = Paths.getSparrowAtlas('debug/backArrowTest');
        /* backButton.animation.addByIndices('idle', 'Arrow BACK', [0], null, 24);
        backButton.animation.addByIndices('hover-Start', 'Arrow BACK', [2, 3, 4, 5], null, 24);
        backButton.animation.addByIndices('hover-Hold', 'Arrow BACK', [4], null, 24);
        backButton.animation.addByIndices('hover-Stop', 'Arrow BACK', [2, 3, 0, 1], null, 24);
        backButton.animation.addByPrefix('clicked', 'Arrow BACK', 48, true); */
        backButton.animation.addByPrefix('idle', 'Arrow IDLE', 24);
        backButton.animation.addByPrefix('hover-Start', 'Arrow HOVER', 24);
        backButton.animation.addByPrefix('hover-Hold', 'Arrow OVER', 24);
        backButton.animation.addByPrefix('hover-Stop', 'Arrow HOVER', 24);
        backButton.animation.addByPrefix('clicked', 'Arrow CLICKED', 48, true);
        backButton.animation.play('idle');
        backButton.setGraphicSize(Std.int(backButton.width * 0.69));
        backButton.updateHitbox();
        backButton.clickable = true;
        // backButton.mousePressedCallback(backButton, backButton.mouseX, backButton.mouseY);
        if (!PlayState.dunFuckedUpNow) add(backButton);
    }
    /**Starts the song. How much more simply would I need to explain that?*/
    inline function beginSong(character:String = 'bf') {
        trace('STOP TALKING ABOUT AMONG US');
        FlxG.sound.music.stop();
        FlxG.sound.playMusic(Paths.music('gameOverEnd', 'shared'));
        if (charShit.hasHey) daBoyf.playAnim(charShit.heyName);
        PlayState.SONG.player1 = character;
        bfOverride = character;
        new FlxTimer().start(0.5, function(tmr:FlxTimer) {
            LoadingState.loadAndSwitchState(new PlayState());
        });
        
    }
    /**used for updatebf*/
    var chump:Int = 0;
    /**Updates the bf on screen.*/
    inline function updateBruhfriend(?change:Int = 0) {
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
        /*if (FileSystem.exists(Paths.modsSelectable(daBoyf.curCharacter))) {//this has been retired in favour of the code below!

            var bullshit = cast Json.parse(sys.io.File.getContent(Paths.modsSelectable(daBoyf.curCharacter)));
            trace(bullshit);
            charShit.characterName = bullshit.characterName;
            charShit.deathCharacter = bullshit.deathCharacter;
            charShit.friendlyName = bullshit.friendlyName;
            charShit.hasHey = bullshit.hasHey;
            charShit.heyName = bullshit.heyName;
        } */
        for (dick in 0...bfInfos.length) {
            if (bfInfos[dick].characterName == daBoyf.curCharacter) {
                charShit = bfInfos[dick];
            }
        }
    }
    public var susOver:Bool = false;
    override function update(elapsed:Float) {
        if (controls.BACK && !PlayState.dunFuckedUpNow) {
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
        if (FlxG.keys.justPressed.B && isModSong && !showingBgMsg) {
            showBgMsg();
        }
        if (FlxG.keys.justPressed.L && !susOver) {
            daBoyf.kill();
            susOver = true;
            openSubState(new GameOverPreview(daBoyf.getGraphicMidpoint().x, daBoyf.getGraphicMidpoint().y, daBoyf.curCharacter)); //daBoyf.curCharacter is a placeholder until I set up the actual selectable shit!
        }

        if (daBoyf != null && FlxG.keys.justPressed.E) {
            trace('editing ' + daBoyf.curCharacter);
        }

        if (backButton != null && backButton.isOnScreen()) {
            backButton.update(elapsed);

            if (backButton.mouseOver) {
                backButton.animation.play('hover-Start');
            }
            if (backButton.animation.curAnim.finished && backButton.animation.curAnim.name == 'hover-Start' && backButton.mouseOver) {
                backButton.animation.play('hover-Hold');
            }
            if (backButton.animation.curAnim.name == 'hover-Hold' && !backButton.mouseOver) {
                backButton.animation.play('hover-Stop');
            }
            if (backButton.animation.curAnim.finished && backButton.animation.curAnim.name == 'hover-Stop') {
                backButton.animation.play('idle');
            }
            if (backButton.isPressed) {
                backButton.animation.play('clicked');
                exitMenu();
            }
            if (startingSong) {
                backButton.clickable = false;
            }
        }
    }
    function exitMenu() {
        if (PlayState.isStoryMode) {
            MusicBeatState.switchState(new StoryMenuState());
        } else {
            MusicBeatState.switchState(new FreeplayState());
        }
    }
    var showingBgMsg:Bool = false;
    function showBgMsg() {
        showingBgMsg = true;
        var msgBg:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        msgBg.alpha = 0.69;
        msgBg.screenCenter();
        add(msgBg);
        var msgBox:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width - 200, FlxG.height - 200, FlxColor.WHITE);
        msgBox.screenCenter();
        add(msgBox);
        var msg:FlxText = new FlxText(0, 0, FlxG.width - 200, 'To make a custom background for your song and display it here, just do the following steps:\n1. Play your song. Get to a point where you think it would be good to take your screenshot.\n2. Take a screenshot of your game window (preferably without the titlebar) and save it to the following path in your game files:\nmods/images/songBack/' + PlayState.SONG.song.toLowerCase() + '.png\n3. Relaunch the game and your background should appear!\n\nThis window will close automatically in 5 seconds.', 24);
        msg.setFormat(Paths.font('funny.ttf'), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLUE);
        msg.screenCenter();
        add(msg);
        new FlxTimer().start(5, function(tmr:FlxTimer) {
            showingBgMsg = false;
            msgBg.destroy();
            msgBox.destroy();
            msg.destroy();
        });
    }
    public static var instance:SelectChara;
}

/**
    I'll move this to its own file later. ANYWAY.
    This state allows you to create a selectable JSON.*/
class SelectableCreatorState extends MusicBeatState {
    /**Template*/
    public static var defaults:String = '{
        "friendlyName": "Bruhfriend",
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
    /**primary camera*/
    var cumCamera:FlxCamera;
    /**joe mama*/
    var joe:CharSelShit;
    /**get list of current selectable characters*/
    var selectables:Array<String> = [];
    /**this is the bg*/
    var cumShot:FlxSprite;
    /**show the bf*/
    var boyWitDaSHOES:Bruhfriend;
    /**show death*/
    var skelly:Bruhfriend;
    
    public function new(?chara:String = 'snowcon') {
        super();
        FlxG.mouse.useSystemCursor = true;
        if (!FlxG.mouse.visible) FlxG.mouse.visible = true;
        if (chara != null) characterName = chara;
        cumCamera = new FlxCamera();
        cumCamera.bgColor.alpha = 0;
        camBruh = new FlxCamera();
        camBruh.bgColor.alpha = 0;
        FlxG.cameras.reset(cumCamera);
        FlxG.cameras.add(camBruh);

        FlxCamera.defaultCameras = [cumCamera];
        if (FileSystem.exists(Paths.modsSelectable(characterName))) joe = cast Json.parse(sys.io.File.getContent(Paths.modsSelectable(characterName))) else joe = cast Json.parse(defaults);
        joe.characterName = characterName;
        trace(joe);
    }
    var cockRing:Array<FlxUIInputText> = [];

    override function create() {
        if (!FlxG.sound.music.playing) {
            FlxG.sound.playMusic(Paths.music('desktop'));
        }
        cumShot = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        cumShot.setGraphicSize(Std.int(cumShot.width * 1.1));
        cumShot.scrollFactor.set();
        cumShot.screenCenter();
        add(cumShot);

        boyWitDaSHOES = new Bruhfriend(0, 0, joe.characterName);
        boyWitDaSHOES.x += boyWitDaSHOES.positionArray[0];
        boyWitDaSHOES.y += boyWitDaSHOES.positionArray[1];
        add(boyWitDaSHOES);

        skelly = new Bruhfriend(0, 0, joe.deathCharacter);
        skelly.x += skelly.positionArray[0] + 350;
        skelly.y = boyWitDaSHOES.y;
        skelly.playAnim('firstDeath');
        add(skelly);
        if (joe.deathCharacter == joe.characterName) skelly.kill();

        var tabs = [
            {name: 'Settings', label: 'Settings'},
        ];

        UI_shit = new FlxUITabMenu(null, tabs, true);
        // UI_shit.cameras = [camBruh];
        UI_shit.resize(350, 250);
        UI_shit.x = FlxG.width - 350;
        UI_shit.y = 25;
        UI_shit.scrollFactor.set();
        add(UI_shit);

        addCumUI();
    }
    var fnameInput:FlxUIInputText;
    var cnameInput:FlxUIInputText;
    var creload:FlxButton;
    var heyBox:FlxUICheckBox;
    var hnameInput:FlxUIInputText;
    var dnameInput:FlxUIInputText;
    var saveButton:FlxButton;
    var dreload:FlxButton;
    var exitButton:FlxButton;
    function addCumUI() {
        var tab_group = new FlxUI(null, UI_shit);
        tab_group.name = "Settings";

        fnameInput = new FlxUIInputText(10, 30, 200, joe.friendlyName, 8);
        cnameInput = new FlxUIInputText(10, fnameInput.y + 35, 200, joe.characterName, 8);
        creload = new FlxButton(cnameInput.x + 200, cnameInput.y, 'RELOAD CHAR.', function() {
            reloadChara(cnameInput.text, 1);
        });
        heyBox = new FlxUICheckBox(10, creload.y + 35, null, null, 'Has hey?', 200);
        heyBox.checked = joe.hasHey;
        heyBox.callback = cumCutely;
        hnameInput = new FlxUIInputText(10, heyBox.y + 35, 200, joe.heyName, 8);
        dnameInput = new FlxUIInputText(10, hnameInput.y + 35, 200, joe.deathCharacter, 8);
        dreload = new FlxButton(dnameInput.x + 200, dnameInput.y, 'RELOAD DEATH', function() {
            reloadChara(dnameInput.text, 0);
        });
        saveButton = new FlxButton(200, 0, 'Save', saveBullshit);
        exitButton = new FlxButton(200, saveButton.y + 50, 'Exit', function() {
            MusicBeatState.switchState(new editors.MasterEditorMenu());
        });

        tab_group.add(new FlxText(10, fnameInput.y - 18, 0, 'Friendly name:'));
        tab_group.add(new FlxText(10, cnameInput.y - 18, 0, 'Character name:'));
        tab_group.add(new FlxText(10, hnameInput.y - 18, 0, 'Hey anim name:'));
        tab_group.add(new FlxText(10, dnameInput.y - 18, 0, 'Death character name:'));
        tab_group.add(fnameInput);
        tab_group.add(cnameInput);
        tab_group.add(creload);
        tab_group.add(heyBox);
        tab_group.add(hnameInput);
        tab_group.add(dnameInput);
        tab_group.add(saveButton);
        tab_group.add(exitButton);
        tab_group.add(dreload);
        cockRing.push(fnameInput);
        cockRing.push(cnameInput);
        cockRing.push(hnameInput);
        cockRing.push(dnameInput);
        UI_shit.addGroup(tab_group);
        UI_shit.color = FlxColor.BLUE;
    }
    function cumCutely() {
        joe.hasHey = !joe.hasHey;
    }
    function reloadChara(name:String, charType:Int) {
        if (charType == 1) {
            boyWitDaSHOES.destroy();
            boyWitDaSHOES = new Bruhfriend(0, 0, name);
            boyWitDaSHOES.x += boyWitDaSHOES.positionArray[0];
            boyWitDaSHOES.y += boyWitDaSHOES.positionArray[1];
            add(boyWitDaSHOES);
            if (!skelly.alive && skelly.curCharacter != boyWitDaSHOES.curCharacter) skelly.revive();
        } else {
            skelly.destroy();
            skelly = new Bruhfriend(0, 0, name);
            skelly.x += skelly.positionArray[0] + 350;
            skelly.y = boyWitDaSHOES.y;
            skelly.playAnim('firstDeath');
            add(skelly);
            if (skelly.curCharacter == boyWitDaSHOES.curCharacter) skelly.kill();
        }
    }
    var _file:FileReference;
    function saveBullshit() {
        var json = {
            "friendlyName": fnameInput.text,
            "characterName": cnameInput.text,
            "hasHey": joe.hasHey,
            "heyName": hnameInput.text,
            "deathCharacter": dnameInput.text,
        };

        var piss:String = Json.stringify(json, "\t");

        if (piss.length > 0)
            {
            // openSubState(new SavingYourBullshit('bf'));
            _file = new FileReference();
            _file.addEventListener(Event.COMPLETE, onSaveComplete);
            _file.addEventListener(Event.CANCEL, onSaveCancel);
            _file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file.save(piss, joe.characterName + ".json");
        }
    }
    function onSaveComplete(_):Void
        {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
        FlxG.log.notice("Successfully saved file.");
    }
    function onSaveCancel(_):Void
        {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
    }
    function onSaveError(_):Void
        {
        _file.removeEventListener(Event.COMPLETE, onSaveComplete);
        _file.removeEventListener(Event.CANCEL, onSaveCancel);
        _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        _file = null;
        FlxG.log.error("Problem saving file");
    }
    override function update(elapsed:Float) {
        if (boyWitDaSHOES != null) {
            boyWitDaSHOES.update(elapsed);
        }
        if (skelly != null && skelly.alive) {
            skelly.update(elapsed);
        }

        if (UI_shit != null) {
            UI_shit.update(elapsed);
        }

        if (cockRing.length >= 1) {
            for (balls in cockRing) {
                if (balls.hasFocus) {
                    FlxG.sound.muteKeys = [];
                    FlxG.sound.volumeDownKeys = [];
                    FlxG.sound.volumeUpKeys = [];
                    break;
                } else {
                    FlxG.sound.muteKeys = TitleState.muteKeys;
                    FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
                    FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
                    break;
                }
            }
        }
        /* if (skelly != null && !skelly.alive) {
            sameTxt.revive();
        }*/
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

/**test*/
class SCThing extends MusicBeatSubstate {
    var shutup:FlxUIInputText;
    var okAss:FlxButton;
    
    public function new() {
        super();
        if (!FlxG.mouse.visible) FlxG.mouse.visible = true;
        var fuckyou:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0,0,0,128));
        fuckyou.screenCenter();
        add(fuckyou);
        shutup = new FlxUIInputText(0,0,200,null,8);
        shutup.screenCenter();
        add(shutup);
        add(new FlxText(shutup.x, shutup.y - 18, FlxG.width, 'enter a character name', 8));
        okAss = new FlxButton(0, 0, 'ok', function() {
            MusicBeatState.switchState(new SelectableCreatorState(shutup.text));
        });
        add(okAss);
    }

    override function update(elapsed:Float) {
        if (shutup != null) {
            shutup.update(elapsed);
        }
        if (okAss != null) {
            okAss.update(elapsed);
        }
    }
}