package editors;

import flixel.input.keyboard.FlxKeyboard;
import flixel.input.FlxBaseKeyList;
import flixel.input.keyboard.FlxKeyList;
import Controls.Device;
import flixel.addons.ui.FlxUIInputText;
import Section.SwagSection;
import Song.SwagSong;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import openfl.events.KeyboardEvent;
import flixel.ui.FlxButton;
import FlxUIDropDownMenuCustom as DropDown;
import flixel.input.keyboard.FlxKeyList;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
import sys.FileStat;
#end
import FunkinLua;

using StringTools;
/**
 *  This state is called upon attempting to test the PlayState via the options menu. **It does not appear outside of release builds!**
 */
class ReleaseRejection extends MusicBeatSubstate {
    private var windowBg:FlxSprite;
    private var eatMyBalls:FlxText;
    private var continueBox:FlxSprite;
    private var eatYourOwnFingers:FlxText;
	private var susTimer:Int = 6;
    public function new() {
        super();
        windowBg = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, 0x69690000);
        windowBg.scrollFactor.set();
        windowBg.screenCenter();
        add(windowBg);
        eatMyBalls = new FlxText(0, 0, FlxG.width, 'You\'re running this on a RELEASE build of the game. As a precaution, the Test PlayState option is disabled on these builds to help prevent potential issues from how messy its code is.\n\nClose in $susTimer second(s)');
        eatMyBalls.screenCenter();
        eatMyBalls.scrollFactor.set();
        eatMyBalls.setFormat(Paths.font('vcr.ttf'), 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(eatMyBalls);
        continueBox = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0x69000000);
        continueBox.scrollFactor.set();
        add(continueBox);
        eatYourOwnFingers = new FlxText(continueBox.x, continueBox.y - 4, FlxG.width, 'Press your ACCEPT keybind to continue.');
        eatYourOwnFingers.setFormat(Paths.font('funny.ttf'), 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		new FlxTimer().start(1, function (tmr:FlxTimer) {
			if (susTimer > 1 || susTimer == 0) eatMyBalls.text = 'You\'re running this on a RELEASE build of the game. As a precaution, the Test PlayState option is disabled on these builds to help prevent potential issues from how messy its code is.\n\nClose in $susTimer seconds' else 'You\'re running this on a RELEASE build of the game. As a precaution, the Test PlayState option is disabled on these builds to help prevent potential issues from how messy its code is.\n\nClose in $susTimer second';
			trace(susTimer);
			--susTimer;
		}, 7);
		new FlxTimer().start(7, function (tmr:FlxTimer) {
			add(eatYourOwnFingers);
		});
    }

    override function update(elapsed:Float) {
        if (susTimer == 0 && controls.ACCEPT) {
            close();
        }
		if (eatMyBalls != null) {
			eatMyBalls.update(elapsed);
		}
    }
}
/**
 *  Brings up UI that asks you to confirm the content you want to test. Currently does NOT support difficulties for songs.
 * 
 * @param callState Integer between 0-2 and 4 that is used for the test `PlayState`.
 * @param contentType Integer between 0-2 that is used to determine content type.
 * @param noteSkin String for a note file name. Defaults to `funnyNotes/bob` (Optional unless testing a noteskin)
 * @param charName String for a character name. Defaults to `bf` (Optional unless testing a character)
 * @param charType String for a character type. Valid options are `bf`, `gf`, and `dad`. Defaults to `bf` (Ditto with `charName`)
 * @param songName String for a song name. Defaults to `bussy-sharts` (Optional unless testing a song)
 */
class ConfirmYourContent extends MusicBeatSubstate {
    private var windowBg:FlxSprite;
    private var fuckYourMother:FlxText;
    private var characterType:DropDown;
    private var selType:String;
    private var characterName:DropDown;
    private var selChar:String;
    private var noteskinName:FlxUIInputText;
    private var testSongBox:FlxUIInputText;
    private var selNS:String;
    private var testingSong:String;
    private var returnState:String = 'Main Menu';
    var lmfao:String;
    var fuckMyDad:FlxSprite;

    public function new (callState:Int, contentType:Int, ?noteSkin:String = 'funnyNotes/bob', ?charName:String = 'bf', ?charType:String = 'bf', ?songName:String = 'bussy-sharts') {
        super();
        switch (callState) {
            case 0: // called from chartingstate
                returnState = 'Chart Editor';
            case 1: // called from character editor
                returnState = 'Character Editor';
            case 2: // called from unlock editor
                returnState = 'Unlock Editor';
            case 4: 
                returnState = 'Options Menu';
            default: // how the fuck did we get here
                trace('how did we get here');
        }
        switch (contentType) { // IT IS REQUIRED TO ADD THE ASSOCIATED CONTENT TYPE'S ARGS! I've hardcoded some defaults for the rest of the args that'll be set for other content types unless you decide to specify them anyway.
            case 0: // character | example args: (1, 0, null, 'bf', 'bf') / (1, 0, 'funnyNotes/bob', 'bf', 'bf', 'tutorial-fns')
                if (noteSkin != null) selNS = noteSkin else selNS = 'funnyNotes/bob';
                selChar = charName;
                selType = charType;
                if (songName != null) testingSong = songName else testingSong = 'bussy-sharts';
                lmfao = 'character';
            case 1: // song | example args: (0, 1, null, null, null, 'farting-with-reverb') / (0, 1, 'funnyNotes/bosip', 'gundam', 'dad', 'philly-nice')
                if (noteSkin != null) selNS = noteSkin else selNS = 'funnyNotes/bob';
                if (charName != null) selChar = charName else selChar = 'cupcakke';
                if (charType != null) selType = charType else selType = 'dad';
                testingSong = songName;
                lmfao = 'song';
            case 2: // noteskin | example args: (2, 2, 'sex') / (0, 2, 'funnyNotes/penis', 'pico-player', 'bf', 'fresh')
                selNS = noteSkin;
                if (charName != null) selChar = charName else selChar = 'cupcakke';
                if (charType != null) selType = charType else selType = 'dad';
                if (songName != null) testingSong = songName else testingSong = 'bussy-sharts';
                lmfao = 'character';
        }
        trace('test so we dont crash');
        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
        }
        // close();
    }

    override function create() {
        windowBg = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, 0xFF000069);
        windowBg.alpha = 0.69;
        windowBg.screenCenter();
        windowBg.scrollFactor.set();
        add(windowBg);
        fuckMyDad = new FlxSprite(0).makeGraphic(FlxG.width, 26, 0x69000069);
        fuckMyDad.scrollFactor.set();
        add(fuckMyDad);
        fuckYourMother = new FlxText(0, fuckMyDad.y + 4, FlxG.width, 'Please make sure the options below are correct before we continue:', 24);
        fuckYourMother.setFormat(Paths.font('funny.ttf'), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
        fuckYourMother.screenCenter(X);
        add(fuckYourMother);
        addSongBox();
        addSussyBaka();
        addCharacterDrops();
        addConfirmationButtons();
    }
    var characterList:Array<String> = [];
    var preloadChars = FileSystem.readDirectory('assets/characters');
    var modChars = FileSystem.readDirectory('mods/characters');
    private function addCharacterDrops() {
        for (i in 0...preloadChars.length) {
            trace('ass');
            characterList.push(preloadChars[i].substring(0, preloadChars[i].length - 5));
        }
        characterName = new DropDown(150, 150, DropDown.makeStrIdLabelArray(characterList, true), function (character:String) {
            trace(characterName.selectedLabel);
            selChar = characterName.selectedLabel;
        });
        characterName.selectedLabel = selChar;
        add(characterName);
        characterType = new DropDown(300, 150, DropDown.makeStrIdLabelArray(['bf', 'dad', 'gf'], true), function (chartype:String) {
            trace(characterType.selectedLabel);
            selType = characterType.selectedLabel;
        });
        characterType.selectedLabel = selType;
        add(characterType);
        var nameLabel:FlxText = new FlxText(characterName.x, characterName.y - 16, 0, 'Character Name:');
        add(nameLabel);
        var typeLabel:FlxText = new FlxText(characterType.x, characterType.y - 16, 0, 'Character type:');
        add(typeLabel);
    }

    private function addSongBox() {
        testSongBox = new FlxUIInputText(150, 300, 70, testingSong, 8);
        add(testSongBox);
        var songLabel = new FlxText(testSongBox.x, testSongBox.y - 16, 0, 'Song: ');
        add(songLabel);
    }

    private function addSussyBaka() {
        noteskinName = new FlxUIInputText(300, 300, 150, selNS, 8);
        add(noteskinName);
        var noteskinLabel = new FlxText(noteskinName.x, noteskinName.y - 16, 0, 'Noteskin:');
        add(noteskinLabel);
    }
    var confirmButton:FlxButton;
    var cancelButton:FlxButton;
    private function addConfirmationButtons() {
        confirmButton = new FlxButton(648, 530, "Let's go!", function () {
            PlayState.SONG = Song.loadFromJson(testingSong, testingSong.toLowerCase());
            PlayState.SONG.arrowSkin = selNS;
            LoadingState.loadAndSwitchState(new TestPlayState(returnState, [lmfao, selNS, selChar, selType, testingSong]));
        });
        confirmButton.color = FlxColor.GREEN;
        confirmButton.label.color = FlxColor.WHITE;
        cancelButton = new FlxButton(778, 530, "Never mind...", function () {
            trace('cancel');
            close();
        });
        cancelButton.color = FlxColor.RED;
        cancelButton.label.color = FlxColor.WHITE;
        add(confirmButton);
        add(cancelButton);
    }

    override function update(elapsed:Float) {
        if (noteskinName != null && !noteskinName.hasFocus && selNS != noteskinName.text) {
            selNS = noteskinName.text;
        }
        if (testSongBox != null && !testSongBox.hasFocus && testingSong != testSongBox.text) {
            testingSong = testSongBox.text;
        }
        if (confirmButton != null) {
            confirmButton.update(elapsed);
        }
        if (cancelButton != null) {
            cancelButton.update(elapsed);
        }
        if (noteskinName != null) {
            noteskinName.update(elapsed);
        }
        if (testSongBox != null) {
            testSongBox.update(elapsed);
        }
        if (characterName != null) {
            characterName.update(elapsed);
        }
        if (characterType != null) {
            characterType.update(elapsed);
        }
    }
}
/**
 *  Test variant of the PlayState. Pretty much based off `EditorPlayState`.
 * 
 * @param returning String that determines what state to return the player to upon completion of song (or ESC press)
 * @param whatWeNeedLmao Dynamic array, usually containing 5 strings passed from `ConfirmYourContent`.
 * @param startPos Float value to start the song at a specific point. (Optional, but highly recommended if calling from `ChartingState` in the future!)
 */
class TestPlayState extends MusicBeatState
{
	// Yes, this is mostly a copy of PlayState, it's kinda dumb to make a direct copy of it but... ehhh
	private var strumLine:FlxSprite;
	private var comboGroup:FlxTypedGroup<FlxSprite>;
	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];

    public var player:Boyfriend;
    public var babaGrill:Character;
    public var hotDad:Character;
    var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	var generatedMusic:Bool = false;
	var vocals:FlxSound;

    var returnState:String = 'Main Menu';
    var testContent:Array<Dynamic>;
    var characterName:String;
    var weTestin:String;
    var characterType:String;
    var ourNoteskin:String;
    var songName:String;

	var startOffset:Float = 0;
	var startPos:Float = 0;

	public function new(returning:String, whatWeNeedLmao:Array<Dynamic>, ?startPos:Float) {
		if (startPos != null) {
            this.startPos = startPos;
		Conductor.songPosition = startPos - startOffset;
        }

		startOffset = Conductor.crochet;
		timerToStart = startOffset;
        trace('checking the test content lmfao');
        returnState = returning;
        testContent = whatWeNeedLmao;
        checkTestContent(testContent);
		super();
	}

	var scoreTxt:FlxText;
	var stepTxt:FlxText;
	var beatTxt:FlxText;
	
	var timerToStart:Float = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	
	// Less laggy controls
	private var keysArray:Array<Dynamic>;

	public static var instance:TestPlayState;

    private inline function checkTestContent(testContent:Array<Dynamic>) {
        var exampleTestContent:Array<Dynamic> = ['character', 'funnyNotes/bob', 'bf', 'bf', 'milf']; // THIS IS AN EXAMPLE ARRAY.
        for (i in 0...testContent.length) {
            switch (i) {
                case 0:
                    weTestin = testContent[0];
                case 1:
                    ourNoteskin = testContent[1];
                case 2:
                    characterName = testContent[2];
                case 3:
                    characterType = testContent[3];
                case 4:
                    songName = testContent[4];
                    setupSong(characterType, characterName);
            }
        }
    }

    private function setupSong(charType:String = 'bf', charName = 'bf') {
        trace('lets get your song set up');
        trace(charType);
        switch (charType) {
            case 'bf':
                player = new Boyfriend(728, 450, charName);
                babaGrill = new Character(500, 100, 'gungf', true);
                hotDad = new Character(100, 450, 'coldfront', true);
            case 'gf':
                player = new Boyfriend(728, 450, 'bf');
                babaGrill = new Character(500, 100, charName, true);
                hotDad = new Character(100, 450, 'coldfront', true);
            case 'dad':
                player = new Boyfriend(728, 450, 'bf');
                babaGrill = new Character(500, 150, 'gungf', true);
                hotDad = new Character(100, 450, charName, true);
            default:
                player = new Boyfriend(728, 450, 'bf');
                babaGrill = new Character(500, 150, 'gungf', true);
                hotDad = new Character(100, 450, 'coldfront', true);
        }
        trace(player);
        trace(babaGrill);
        trace(hotDad);
    }
    /**
     * Made as a way of checking if types match. Supposed to return `true` if `weCheckin` matches `weLookinFor`.
     * @param weCheckin What are we looking to check the type of?
     * @param weLookinAt What are we looking to check the type against?
     * @param weLookinFor What type are we looking for?
     * @return Bool Returns `true` if types match, otherwise false.
     */
    private inline static function typesMatch(weCheckin:Dynamic, weLookinAt:Dynamic, weLookinFor:Dynamic):Bool {
        #if linux
		if (Std.is(Type.typeof(weCheckin), Type.typeof(weLookinFor)) && Std.is(Type.typeof(weLookinAt), Type.typeof(weLookinFor)) && Std.is(weCheckin, weLookinAt)) {
		#else
		if (Std.isOfType(weCheckin, weLookinFor) && Std.isOfType(weLookinAt, weLookinFor) && Std.isOfType(weCheckin, weLookinAt)) {
		#end
            return true;
        } else {
            FlxG.log.warn(weCheckin + ' is not of type ' + weLookinFor + '; Type: ' + Type.typeof(weCheckin));
            trace(weCheckin + ' is not of type ' + weLookinFor + '; Type: ' + Type.typeof(weCheckin));
            return false;
        }
    }

	override function create()
	{
		instance = this;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set();
		bg.color = FlxColor.fromHSB(FlxG.random.int(0, 359), FlxG.random.float(0, 0.8), FlxG.random.float(0.3, 1));
		add(bg);

		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];
		
		strumLine = new FlxSprite(ClientPrefs.middleScroll ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();
		
		comboGroup = new FlxTypedGroup<FlxSprite>();
		add(comboGroup);

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);

		generateStaticArrows(0);
		generateStaticArrows(1);
		/*if(ClientPrefs.middleScroll) {
			opponentStrums.forEachAlive(function (note:StrumNote) {
				note.visible = false;
			});
		}*/
		
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		add(grpNoteSplashes);

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;
		
		if (PlayState.SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();
        trace(player);
        trace(babaGrill);
        babaGrill.scrollFactor.set(0.95, 0.95);
        add(babaGrill);
        add(player);
        trace(hotDad);
        add(hotDad);
        FlxG.camera.zoom -= 0.5;
		generateSong(PlayState.SONG.song);
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys()) {
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if(sys.FileSystem.exists(luaToLoad)) {
				var lua:editors.EditorLua = new editors.EditorLua(luaToLoad);
				new FlxTimer().start(0.1, function (tmr:FlxTimer) {
					lua.stop();
					lua = null;
				});
			}
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;

		scoreTxt = new FlxText(0, FlxG.height - 50, FlxG.width, "Hits: 0 | Misses: 0", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		add(scoreTxt);
		
		beatTxt = new FlxText(10, 610, FlxG.width, "Beat: 0", 20);
		beatTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		beatTxt.scrollFactor.set();
		beatTxt.borderSize = 1.25;
		add(beatTxt);

		stepTxt = new FlxText(10, 640, FlxG.width, "Step: 0", 20);
		stepTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		stepTxt.scrollFactor.set();
		stepTxt.borderSize = 1.25;
		add(stepTxt);

		var tipText:FlxText = new FlxText(10, FlxG.height - 24, 0, 'Press ESC to Go Back to ' + returnState, 16);
		tipText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipText.borderSize = 2;
		tipText.scrollFactor.set();
		add(tipText);
		FlxG.mouse.visible = false;

		//sayGo();
		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		super.create();
	}
    function addCharacters(bf:Boyfriend, gf:Character, dad:Character) {
        if (bf != null) {
            add(bf);
        }
        if (gf != null) {
            add(gf);
        }
        if (dad != null) {
            add(dad);
        }
    }
	function sayGo() {
		var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image('go'));
		go.scrollFactor.set();

		go.updateHitbox();

		go.screenCenter();
		go.antialiasing = ClientPrefs.globalAntialiasing;
		add(go);
		FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
			ease: FlxEase.cubeInOut,
			onComplete: function(twn:FlxTween)
			{
				go.destroy();
			}
		});
		FlxG.sound.play(Paths.sound('introGo'), 0.6);
	}

	//var songScore:Int = 0;
	var songHits:Int = 0;
	var songMisses:Int = 0;
	var startingSong:Bool = true;
	private function generateSong(dataPath:String):Void
	{
		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0, false);
		FlxG.sound.music.pause();
		FlxG.sound.music.onComplete = endSong;
		vocals.pause();
		vocals.volume = 0;

		var songData = PlayState.SONG;
		Conductor.changeBPM(songData.bpm);
		
		notes = new FlxTypedGroup<Note>();
		add(notes);
		
		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				if(songNotes[1] > -1) { //Real notes
					var daStrumTime:Float = songNotes[0];
					if(daStrumTime >= startPos) {
						var daNoteData:Int = Std.int(songNotes[1] % 4);

						var gottaHitNote:Bool = section.mustHitSection;

						if (songNotes[1] > 3)
						{
							gottaHitNote = !section.mustHitSection;
						}

						var oldNote:Note;
						if (unspawnNotes.length > 0)
							oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
						else
							oldNote = null;

						var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
						swagNote.mustPress = gottaHitNote;
						swagNote.sustainLength = songNotes[2];
						swagNote.noteType = songNotes[3];
						#if !linux
						if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
						#else
						if(!Std.is(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]];
						#end
						swagNote.scrollFactor.set();

						var susLength:Float = swagNote.sustainLength;

						susLength = susLength / Conductor.stepCrochet;
						unspawnNotes.push(swagNote);

						var floorSus:Int = Math.floor(susLength);
						if(floorSus > 0) {
							for (susNote in 0...floorSus+1)
							{
								oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

								var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(PlayState.SONG.speed, 2)), daNoteData, oldNote, true);
								sustainNote.mustPress = gottaHitNote;
								sustainNote.noteType = swagNote.noteType;
								sustainNote.scrollFactor.set();
								unspawnNotes.push(sustainNote);

								if (sustainNote.mustPress)
								{
									sustainNote.x += FlxG.width / 2; // general offset
								}
								else if(ClientPrefs.middleScroll)
								{
									sustainNote.x += 310;
									if(daNoteData > 1)
									{ //Up and Right
										sustainNote.x += FlxG.width / 2 + 25;
									}
								}
							}
						}

						if (swagNote.mustPress)
						{
							swagNote.x += FlxG.width / 2; // general offset
						}
						else if(ClientPrefs.middleScroll)
						{
							swagNote.x += 310;
							if(daNoteData > 1) //Up and Right
							{
								swagNote.x += FlxG.width / 2 + 25;
							}
						}
						
						if(!noteTypeMap.exists(swagNote.noteType)) {
							noteTypeMap.set(swagNote.noteType, true);
						}
					}
				}
			}
			daBeats += 1;
		}

		unspawnNotes.sort(sortByShit);
		generatedMusic = true;
	}

	function startSong():Void
	{
		startingSong = false;
		FlxG.sound.music.time = startPos;
		FlxG.sound.music.play();
		FlxG.sound.music.volume = 1;
		vocals.volume = 1;
		vocals.time = startPos;
		vocals.play();
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function endSong() {
		LoadingState.loadAndSwitchState(new editors.ChartingState());
	}

	override function update(elapsed:Float) {
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.sound.music.pause();
			vocals.pause();
            switch (returnState) {
                case 'Character Editor':
                    LoadingState.loadAndSwitchState(new editors.CharacterEditorState(characterName));
                case 'Unlock Editor':
                    LoadingState.loadAndSwitchState(new editors.UnlockEditorState());
                case 'Chart Editor':
                    LoadingState.loadAndSwitchState(new editors.ChartingState());
                case 'Options Menu':
                    LoadingState.loadAndSwitchState(new options.OptionsState());
                default: // in case we somehow opened this from another state outside of the ones above ^_^''
                    trace('how did we get here');
                    LoadingState.loadAndSwitchState(new editors.MasterEditorMenu());
            }
		}

		if (startingSong) {
			timerToStart -= elapsed * 1000;
			Conductor.songPosition = startPos - timerToStart;
			if(timerToStart < 0) {
				startSong();
			}
		} else {
			Conductor.songPosition += elapsed * 1000;
		}

		var roundedSpeed:Float = FlxMath.roundDecimal(PlayState.SONG.speed, 2);
		if (unspawnNotes[0] != null)
		{
			var time:Float = 1500;
			if(roundedSpeed < 1) time /= roundedSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}
		
		if (generatedMusic)
		{
			var fakeCrochet:Float = (60 / PlayState.SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				/*if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}*/

				// i am so fucking sorry for this if condition
				var strumX:Float = 0;
				var strumY:Float = 0;
				if(daNote.mustPress) {
					strumX = playerStrums.members[daNote.noteData].x;
					strumY = playerStrums.members[daNote.noteData].y;
				} else {
					strumX = opponentStrums.members[daNote.noteData].x;
					strumY = opponentStrums.members[daNote.noteData].y;
				}

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				var center:Float = strumY + Note.swagWidth / 2;

				if(daNote.copyX) {
					daNote.x = strumX;
				}
				if(daNote.copyY) {
					if (ClientPrefs.downScroll) {
						daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);
						if (daNote.isSustainNote) {
							//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
							if (daNote.animation.curAnim.name.endsWith('end')) {
								daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * roundedSpeed + (46 * (roundedSpeed - 1));
								daNote.y -= 46 * (1 - (fakeCrochet / 600)) * roundedSpeed;
								if(PlayState.isPixelStage) {
									daNote.y += 8;
								} else {
									daNote.y -= 19;
								}
							} 
							daNote.y += (Note.swagWidth / 2) - (60.5 * (roundedSpeed - 1));
							daNote.y += 27.5 * ((PlayState.SONG.bpm / 100) - 1) * (roundedSpeed - 1);

							if(daNote.mustPress || !daNote.ignoreNote)
							{
								if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
									&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
								{
									var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
									swagRect.height = (center - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
						}
					} else {
						daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * roundedSpeed);

						if(daNote.mustPress || !daNote.ignoreNote)
						{
							if (daNote.isSustainNote
								&& daNote.y + daNote.offset.y * daNote.scale.y <= center
								&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (center - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;

								daNote.clipRect = swagRect;
							}
						}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
				{
					if (PlayState.SONG.needsVoices)
						vocals.volume = 1;

					var time:Float = 0.15;
					if(daNote.isSustainNote && !daNote.animation.curAnim.name.endsWith('end')) {
						time += 0.15;
					}
					StrumPlayAnim(true, Std.int(Math.abs(daNote.noteData)) % 4, time);
					daNote.hitByOpponent = true;

					if (!daNote.isSustainNote)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}

				var doKill:Bool = daNote.y < -daNote.height;
				if(ClientPrefs.downScroll) doKill = daNote.y > FlxG.height;

				if (doKill)
				{
					if (daNote.mustPress)
					{
						if (daNote.tooLate || !daNote.wasGoodHit)
						{
							//Dupe note remove
							notes.forEachAlive(function(note:Note) {
								if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 10) {
									note.kill();
									notes.remove(note, true);
									note.destroy();
								}
							});

							if(!daNote.ignoreNote) {
								songMisses++;
								vocals.volume = 0;
							}
						}
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
        if (babaGrill != null) {
            babaGrill.update(elapsed);
            if (curBeat % gfSpeed == 0 && !babaGrill.stunned && babaGrill.animation.curAnim.name != null && !babaGrill.animation.curAnim.name.startsWith("sing"))
                {
                    babaGrill.dance();
                }
        }
        if (player != null) {
            player.update(elapsed);
            player.dance();
        }
        if (hotDad != null) {
            hotDad.dance();
        }
		keyShit();
		scoreTxt.text = 'Hits: ' + songHits + ' | Misses: ' + songMisses;
		beatTxt.text = 'Beat: ' + curBeat;
		stepTxt.text = 'Step: ' + curStep;
		super.update(elapsed);
	}
	
	override public function onFocus():Void
	{
		vocals.play();

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		vocals.pause();

		super.onFocusLost();
	}

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}
	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		//trace('Pressed: ' + eventKey);

		if (key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode))
		{
			if(generatedMusic)
			{
				//more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				//var notesDatas:Array<Int> = [];
				var notesStopped:Bool = false;

				trace('test!');
				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
					{
						if(daNote.noteData == key && !daNote.isSustainNote)
						{
							trace('pushed note!');
							sortedNotesList.push(daNote);
							//notesDatas.push(daNote.noteData);
						}
						canMiss = true;
					}
				});
				sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				if (sortedNotesList.length > 0) {
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes) {
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							} else
								notesStopped = true;
						}
							
						// eee jack detection before was not super good
						if (!notesStopped) {
							goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}

					}
				}
				else if (canMiss && !ClientPrefs.ghostTapping) {
					noteMiss(key);
				}

				//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}

			var spr:StrumNote = playerStrums.members[key];
			if(spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
		}
	}
		
	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		if(key > -1)
		{
			var spr:StrumNote = playerStrums.members[key];
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
		}
		//trace('released: ' + controlArray);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if(key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if(key == keysArray[i][j])
					{
						return i;
					}
				}
			}
		}
		return -1;
	}

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.NOTE_UP;
		var right = controls.NOTE_RIGHT;
		var down = controls.NOTE_DOWN;
		var left = controls.NOTE_LEFT;
		var controlHoldArray:Array<Bool> = [left, down, up, right];
		
		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [controls.NOTE_LEFT_P, controls.NOTE_DOWN_P, controls.NOTE_UP_P, controls.NOTE_RIGHT_P];
			if(controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if(controlArray[i])
						onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
				}
			}
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit 
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit) {
					goodNoteHit(daNote);
				}
			});
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [controls.NOTE_LEFT_R, controls.NOTE_DOWN_R, controls.NOTE_UP_R, controls.NOTE_RIGHT_R];
			if(controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if(controlArray[i])
						onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
				}
			}
		}
	}

	var combo:Int = 0;
	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			switch(note.noteType) {
				case 'Hurt Note': //Hurt note
					noteMiss(note.noteData);
					--songMisses;
					if(!note.isSustainNote) {
						if(!note.noteSplashDisabled) {
							spawnNoteSplashOnNote(note);
						}
					}

					note.wasGoodHit = true;
					vocals.volume = 0;

                    if(player.hasMissAnimations)
                        {
                            var daAlt = '';
                            if(note.noteType == 'Alt Animation') daAlt = '-alt';
                
                            var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + 'miss' + daAlt;
                            player.playAnim(animToPlay, true);
                        }

					if (!note.isSustainNote)
					{
						note.kill();
						notes.remove(note, true);
						note.destroy();
					}
					return;
			}

			if (!note.isSustainNote)
			{
				popUpScore(note);
				combo += 1;
				songHits++;
				if(combo > 9999) combo = 9999;
			}

			playerStrums.forEach(function(spr:StrumNote)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.playAnim('confirm', true);
				}
			});
            if (note.hitByOpponent) {
                opponentNoteHit(note);
            }
			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

    function opponentNoteHit(note:Note):Void
        {
            /* if (Paths.formatToSongPath(SONG.song) != 'tutorial')
                camZooming = true; */
    
            if(note.noteType == 'Hey!' && hotDad.animOffsets.exists('hey')) {
                hotDad.playAnim('hey', true);
                hotDad.specialAnim = true;
                hotDad.heyTimer = 0.6;
            } else if(!note.noAnimation) {
                var altAnim:String = "";
    
                var curSection:Int = Math.floor(curStep / 16);
                /* if (SONG.notes[curSection] != null)
                {
                    if (SONG.notes[curSection].altAnim || note.noteType == 'Alt Animation') {
                        altAnim = '-alt';
                    }
                } */
    
                var char:Character = hotDad;
                var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + altAnim;
                if(note.gfNote) {
                    char = babaGrill;
                }
    
                char.playAnim(animToPlay, true);
                char.holdTimer = 0;
            }
    
            /* if (SONG.needsVoices)
                vocals.volume = 1; */
    
            var time:Float = 0.15;
            if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
                time += 0.15;
            }
            StrumPlayAnim(true, Std.int(Math.abs(note.noteData)) % 4, time);
            note.hitByOpponent = true;
    
            // callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote]);
    
            if (!note.isSustainNote)
            {
                note.kill();
                notes.remove(note, true);
                note.destroy();
            }
        }

	function noteMiss(direction:Int = 1):Void
	{
		combo = 0;

		//songScore -= 10;
		songMisses++;

		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
		vocals.volume = 0;
	}

	var COMBO_X:Float = 400;
	var COMBO_Y:Float = 340;
	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);

		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.x = COMBO_X;
		coolText.y = COMBO_Y;
		//

		var rating:FlxSprite = new FlxSprite();
		//var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'shit';
			//score = 50;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.5)
		{
			daRating = 'bad';
			//score = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
			//score = 200;
		}

		if(daRating == 'sick' && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
		}
		//songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
			*/

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (PlayState.isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.visible = !ClientPrefs.hideHud;
		rating.x += ClientPrefs.comboOffset[0];
		rating.y -= ClientPrefs.comboOffset[1];

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.visible = !ClientPrefs.hideHud;
		comboSpr.x += ClientPrefs.comboOffset[0];
		comboSpr.y -= ClientPrefs.comboOffset[1];

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		comboGroup.add(rating);

		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * PlayState.daPixelZoom * 0.85));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * PlayState.daPixelZoom * 0.85));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			numScore.x += ClientPrefs.comboOffset[2];
			numScore.y -= ClientPrefs.comboOffset[3];

			if (!PlayState.isPixelStage)
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * PlayState.daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			numScore.visible = !ClientPrefs.hideHud;

			if (combo >= 10 || combo == 0)
				insert(members.indexOf(strumLineNotes), numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
			*/

		coolText.text = Std.string(seperatedScore);
		// comboGroup.add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	private function generateStaticArrows(player:Int, ?noteskin:String):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var targetAlpha:Float = 1;
			if (player < 1 && ClientPrefs.middleScroll) targetAlpha = 0.35;

			var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X, strumLine.y, i, player);
			babyArrow.alpha = targetAlpha;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				if(ClientPrefs.middleScroll)
				{
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
		}
	}


	// For Opponent's notes glow
	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}


	// Note splash shit, duh
	function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;
		
		var hue:Float = ClientPrefs.arrowHSV[data % 4][0] / 360;
		var sat:Float = ClientPrefs.arrowHSV[data % 4][1] / 100;
		var brt:Float = ClientPrefs.arrowHSV[data % 4][2] / 100;
		if(note != null) {
			skin = note.noteSplashTexture;
			hue = note.noteSplashHue;
			sat = note.noteSplashSat;
			brt = note.noteSplashBrt;
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}
	
	override function destroy() {
		FlxG.sound.music.stop();
		vocals.stop();
		vocals.destroy();

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		super.destroy();
	}

	var gfSpeed:Float = 1;
}
