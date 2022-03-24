package options;

import options.profileManagement.ProfileManagementState;
import lime.system.System;
import editors.TestPlayState.ConfirmYourContent;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import lime.app.Application;
import Controls;
import randomShit.util.HintMessageAsset;

using StringTools;
/**
 *  An extra options menu so I can have all my shit and not have things go off screen.
 *  This is literally a clone of the OptionsState file.
 *  @since March 2022 (Emo Engine 0.1.2)
 */
class OptionsStateExtra extends MusicBeatState
{
	var options:Array<String> = ['Visit Snowdrift', 'Profile Management', 'Test Dialogue', 'Character List', 'Bonk Test', 'Hide Characters', #if debug 'Cvm Format Manager', #end 'Favourite Characters', 'Reset Save Data'];
	var optionsOnPage:Array<String> = []; // this contains the options on the current page. lmao
	static var startFrom:Int = 0; // FOR MULTIPLE PAGES!
	static var endAt:Int = 5;
	static var curPage:Int = 1;
	var maxPages:Int = 0;
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	var pageHint:HintMessageAsset;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Reset Save Data':
				LoadingState.loadAndSwitchState(new options.ResetDataState());
			case 'Visit Snowdrift':
				if (!FlxG.save.data.seenSnowdriftIntro || PlayState.dunFuckedUpNow) {
					LoadingState.loadAndSwitchState(new options.SnowdriftStuff.SnowdriftIntro());
				} else {
					openSubState(new options.SnowdriftStuff());
				}
				// doSnowdriftSaveChecks(); // THIS'LL COME IN LATER!!
            case 'Test Dialogue':
                LoadingState.loadAndSwitchState(new randomShit.dumb.DialogueTestingState());
			case 'Bonk Test':
				LoadingState.loadAndSwitchState(new randomShit.dumb.BonkTest());
			case 'Hide Characters':
				openSubState(new options.HiddenCharactersSubstate());
			#if debug
			case 'Cvm Format Manager':
				openSubState(new options.CvmFormatManager());
			#end
			case 'Favourite Characters':
				LoadingState.loadAndSwitchState(new options.FavouriteCharas());
			case 'Profile Management':
				LoadingState.loadAndSwitchState(new options.profileManagement.ProfileManagementState());
			case 'Character List':
				LoadingState.loadAndSwitchState(new options.charas.CharacterList());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end
		if (maxPages == 0) doMaxPages();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFa6d388;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		if (options.length >= 6) {
			trace('penis');
			#if debug
			FlxG.log.warn('I LOVE LEAN!!!!!');
			#end
			pageHint = new HintMessageAsset('Page ' + curPage + ' of ' + maxPages, 24, ClientPrefs.smallScreenFix);
			add(pageHint);
			add(pageHint.ADD_ME);
		}

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);
		for (i in startFrom...endAt) {
			optionsOnPage.push(options[i]);
		}
		for (i in 0...optionsOnPage.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, optionsOnPage[i], true, false);
			trace(optionText.text);
			optionText.screenCenter();
			optionText.y += (100 * (i - (optionsOnPage.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true, false);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true, false);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}
	function doMaxPages() {
		var curOpts:Int = 1;
		var optsPerPage:Int = 6;
		var optsInGroup:Int = 0;
		var pageCount:Int = 1;
		for (i in 0...options.length) {
			if (i > 0) curOpts++;
			optsInGroup++;
			if (optsInGroup == optsPerPage) {
				pageCount += 1;
				optsInGroup = 0;
			}
		}
		maxPages = pageCount;
	}
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.UI_RIGHT_P) {
			doPageChecks(1);
		}

		if (controls.UI_LEFT_P) {
			doPageChecks(-1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			/* FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0); */ //dont need it

		FlxG.sound.music.fadeIn(4, 0, 0.7);
			FlxG.switchState(new OptionsState());
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = optionsOnPage.length - 1;
		if (curSelected >= optionsOnPage.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function doPageChecks(PageChange:Int = 0) {
		if (options.length >= 6) {
			switch(PageChange) {
				case 1:
					trace('next page');
					startFrom += 6;
					endAt += 6; // SHOULD BE STARTFROM = 6, ENDAT = 11 FOR SECOND PAGE.
					if (startFrom > options.length - 6) {
						startFrom = 0;
						endAt = 5; // RESETS
					}
					if (startFrom < options.length - 6 && endAt > options.length) {
						endAt = options.length;
					}
					curPage += 1;
				case -1:
					trace('prev page');
					startFrom -= 6;
					endAt -= 6;
					if (startFrom < options.length) {
						startFrom = options.length - 6;
						endAt = options.length; // RESETS TO LAST PAGE.
					}
					if (curPage < 1) {
						curPage = maxPages;
					}
			}
			MusicBeatState.resetState(); // TO RESET STATE!
		}
	}

	function doSnowdriftSaveChecks() {
		trace('have we unlocked anything new??');
		switch(FlxG.save.data.snowdriftVisitCount) {
			case 0:
				trace('gotta do intro!');
				LoadingState.loadAndSwitchState(new options.SnowdriftStuff.SnowdriftIntro());
			case 10:
				trace('ok lets unlock the guide thingy');
				LoadingState.loadAndSwitchState(new randomShit.SnowdriftUnlockState());
		}
	}
}