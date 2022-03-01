package;

import DialogueBoxPsych;
import haxe.Json;
import options.SnowdriftStuff.SnowdriftIntro;
import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import Random;
import FunkinLua;

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Boyfriend;
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var updateCamera:Bool = false;

	var stageSuffix:String = "";

	public static var characterName:String = 'bf';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';
	public static var inDialogue:Bool = false;
	var holyShit:DialogueFile;
	static var PeaceChance:Int = Random.int(0, 100);
	static var debugPeaceTrace:Array<String> = ["Oh, we're doing it this way, eh? Aight.", "C'mon, just let the thing happen naturally.", "You're boring.", "I guess you really need that help."];

	public static var instance:GameOverSubstate;
	

	public static function resetVariables() {
		characterName = 'henry';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';
		PeaceChance = Random.int(0,100);
	}

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);
		if (SnowdriftIntro.bambiHarassment && !PlayState.fwys && SelectChara.bfOverride != 'bf') new FlxTimer().start(5, function(tmr:FlxTimer) {
			inDialogue = true;
			holyShit = cast Json.parse(Paths.snowdriftChatter('gameOver'));
			startDialogue(holyShit);
		});

		super.create();
	}
	var psychDialogue:DialogueBoxPsych;
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
		{
			// TO DO: Make this more flexible, maybe?
			if(psychDialogue != null) return;
	
			if(dialogueFile.dialogue.length > 0) {
				if (!inDialogue) inDialogue = true;
				CoolUtil.precacheSound('dialogue');
				CoolUtil.precacheSound('dialogueClose');
				psychDialogue = new DialogueBoxPsych(dialogueFile);
				psychDialogue.scrollFactor.set();
				if(SnowdriftIntro.bambiHarassment && !PlayState.fwys) {
					psychDialogue.finishThing = function() {
						psychDialogue = null;
						SelectChara.bfOverride = 'bf';
						PlayState.SONG.gfVersion = 'deddrift-gf';
						inDialogue = false;
						endBullshit();
					}
				} else if (PlayState.fwys) {
					psychDialogue.finishThing = function() {
						psychDialogue = null;
						inDialogue = false;
						endBullshit();
					}
				} else {
					psychDialogue.finishThing = function() {
						psychDialogue = null;
						inDialogue = false;
						trace('ass');
					}
				}
				psychDialogue.nextDialogueThing = startNextDialogue;
				psychDialogue.skipDialogueThing = skipDialogue;
				// psychDialogue.cameras = [camHUD];
				add(psychDialogue);
			} else {
				FlxG.log.warn('Your dialogue file is badly formatted!');
				if(SnowdriftIntro.bambiHarassment) {
					trace('wtf');
				} else {
					trace('wtf');
				}
			}
		}
	var dialogueCount:Int = 0;
	function startNextDialogue() {
		dialogueCount++;
	}
	function skipDialogue() {
		trace('penis');
	}
	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		super();
		if (characterName == 'decktop-were') trace('bf was decktop hopefully that\' was correct for whoever the fuck you were playing as') else trace('bf was ' + characterName + ' hopefully that\' was correct for whoever the fuck you were playing as');
		#if debug
		trace('Peace chance is ' + PeaceChance + '!');
		#end
		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		boyfriend = new Boyfriend(x, y, characterName);
		boyfriend.x += boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1];
		add(boyfriend);

		camFollow = new FlxPoint(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);

		FlxG.sound.play(Paths.sound(deathSoundName));
		Conductor.changeBPM(100);
		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');

		var exclude:Array<Int> = [];

		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		add(camFollowPos);
	}

	var isFollowingAlready:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);
		if(updateCamera) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 0.6, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}
		if (psychDialogue != null) {
			psychDialogue.update(elapsed);
		}
		if (controls.ACCEPT && !inDialogue)
		{
			endBullshit();
		}
		#if debug
		if (FlxG.keys.justReleased.P) {
			if (PeaceChance <= 60) PeaceChance = 69 else PeaceChance = 20;
			trace(debugPeaceTrace[Random.int(0, debugPeaceTrace.length - 1)]);
			endBullshit();
		}
		#end

		if (controls.BACK && !PlayState.fwys)
		{
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;

			if (PlayState.isStoryMode)
				MusicBeatState.switchState(new StoryMenuState());
			else
				MusicBeatState.switchState(new FreeplayState());

			if (!TitleState.fuckinAsshole) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			} else {
				FlxG.sound.playMusic(Paths.music('clownTheme'));
			}
			PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
		}

		if (controls.BACK && PlayState.fwys) {
			holyShit = cast Json.parse(Paths.snowdriftChatter('ntShout'));
			startDialogue(holyShit);
		}

		if (boyfriend.animation.curAnim.name == 'firstDeath')
		{
			if(boyfriend.animation.curAnim.curFrame >= 12 && !isFollowingAlready)
			{
				FlxG.camera.follow(camFollowPos, LOCKON, 1);
				updateCamera = true;
				isFollowingAlready = true;
			}

			if (boyfriend.animation.curAnim.finished)
			{
				coolStartDeath();
				boyfriend.startedDeath = true;
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	override function beatHit()
	{
		super.beatHit();

		//FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}
	/* public function callOnBfLuas(event:String, args:Array<Dynamic>):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			var ret:Dynamic = luaArray[i].call(event, args);
			if(ret != FunkinLua.Function_Continue) {
				returnVal = ret;
			}
		}

		for (i in 0...closeLuas.length) {
			luaArray.remove(closeLuas[i]);
			closeLuas[i].stop();
		}
		#end
		return returnVal;
	} */
	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			/* if (PeaceChance >= 60) {
				FlxG.camera.fade(FlxColor.RED, 2, false, function()
					{
						openSubState(new PeaceTranquilitySubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, camFollowPos.x, camFollowPos.y));
						boyfriend.visible = false;
						closeSubState();
					});
				
			} else { // Peace and Tranquility substate is gitignored, GAME WON'T WORK WITHOUT COMMENT!! */
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
		// }
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}
}
