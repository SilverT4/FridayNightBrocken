package;

import editors.HealthIconFromGrid;
import editors.CharacterEditorState;
import lime.app.Application;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxState;
import flixel.FlxBasic;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create() {
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		super.create();
		Application.current.window.onFocusIn.add(onWindowFocusIn);
		Application.current.window.onFocusOut.add(onWindowFocusOut);
		// Custom made Trans out
		if(!skip) {
			openSubState(new CustomFadeTransition(1, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
	}
	
	#if (VIDEOS_ALLOWED && windows && !debug)
	override public function onFocus():Void
	{
		FlxVideo.onFocus();
		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		FlxVideo.onFocusLost();
		super.onFocusLost();
	}
	#end
	#if debug
	static var pussyShit:FlxSprite;
	override public function onFocus():Void
		{
			#if (VIDEOS_ALLOWED && windows) FlxVideo.onFocus(); #end
			FocusLostScreen.weGotFocus();
			yeet(pussyShit);
			super.onFocus();
		}
	override public function onFocusLost():Void {
		var fuckMyAss:Bool = true;
		pussyShit = new FlxSprite();
		pussyShit.makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
		pussyShit.alpha = 0;
		add(pussyShit);
		#if (VIDEOS_ALLOWED && windows) FlxVideo.onFocusLost(); #end
		FlxTween.tween(pussyShit, { alpha: 0.7 }, 0.7, { onComplete: function(Pussy:FlxTween) {
			openSubState(new FocusLostScreen());
		}});
		new FlxTimer().start(0.7, function(PissInMy:FlxTimer) {
			fuckMyAss = false;
			pissOnMyBussy();
		});
	}
	function pissOnMyBussy() {
		super.onFocusLost();
	}
	public static function removeTheBullshit() {
		FlxTween.tween(pussyShit, { alpha: 0 }, 0.7, { onComplete: function(Pussy:FlxTween) {
			pussyShit.destroy();
			pussyShit = null;
		}});
	}
	#end

	public function yeet(Object:flixel.FlxBasic) {
		if (Object.exists) {
			remove(Object);
		}
	}
	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor(((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / Conductor.stepCrochet);
	}

	public static function switchState(nextState:FlxState) {
		// Custom made Trans in
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		if(!FlxTransitionableState.skipNextTransIn) {
			leState.openSubState(new CustomFadeTransition(0.7, false));
			if(nextState == FlxG.state) {
				CustomFadeTransition.finishCallback = function() {
					FlxG.resetState();
				};
				//trace('resetted');
			} else {
				CustomFadeTransition.finishCallback = function() {
					FlxG.switchState(nextState);
				};
				//trace('changed state');
			}
			return;
		}
		FlxTransitionableState.skipNextTransIn = false;
		FlxG.switchState(nextState);
	}

	public static function resetState() {
		MusicBeatState.switchState(FlxG.state);
	}

	public static function getState():MusicBeatState {
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		return leState;
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}

	function onWindowFocusIn():Void {
		trace('welcome back lmao');
		if (CharacterEditorState.savingYourShit) {
			CharacterEditorState.savingYourShit = false;
		}
		if (HealthIconFromGrid.instance != null && HealthIconFromGrid.instance.loadin) {
			HealthIconFromGrid.instance.loadin = false;
		}
		//if (FocusLostScreen.isOpen) FocusLostScreen.weGotFocus();
	}

	function onWindowFocusOut():Void {
		if (CharacterEditorState.savingYourShit) {
			trace('ewwwww save dialog');
			// openSubState(new SavingYourBullshit('blitz'));
		}
		//openSubState(new FocusLostScreen());
	}
}
