package;

import flixel.addons.ui.FlxUICheckBox;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.ui.FlxButton;

using StringTools;
/**
    this is a test substate to see if i can create a pause menu that uses UI instead of a menu idk
    @author devin503
    */
class FunnySandwich extends MusicBeatSubstate {
    /**
        Literally closes the substate.
        */
    var resumeButton:FlxButton;
    /**
        Restarts the current song
        */
    var restartButton:FlxButton;
    /**
        Exits song to main menu
        */
    var quitButton:FlxButton;
    var botplayCheckbox:FlxUICheckBox;
    var trollButton:FlxUICheckBox;
    var fuckYou:FlxCamera;
    /**
        For ease of coding at the moment, I'm setting this to open the PauseSubState to the difficulty menu.
        */
    var difficultyButton:FlxButton;
    var optionDescription:FlxText;

    public function new(x:Float, y:Float) {
        super();
        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
            FlxG.mouse.useSystemCursor = true;
        }
        fuckYou = new FlxCamera();
        fuckYou.bgColor.alpha = 0;
        FlxG.cameras.add(fuckYou);
        trace('test, press ESC to exit');
        var bg:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.69;
        bg.cameras = [fuckYou];
        add(bg);
        var testMsg:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, FlxColor.fromRGB(0, 0, 0, 128));
        testMsg.cameras = [fuckYou];
        add(testMsg);
        var testMess:FlxText = new FlxText(8, testMsg.y + 4, FlxG.width - 8, 'This is a TEST menu! To use the regular pause menu, press the backspace key in a song!', 24);
        testMess.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        testMess.cameras = [fuckYou];
        add(testMess);
        var descBg:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, 26, FlxColor.fromRGB(0, 0, 0, 128));
        descBg.cameras = [fuckYou];
        add(descBg);
        optionDescription = new FlxText(1, 4, FlxG.width - 1, 'Press ESCAPE if you see this for more than 5 seconds!');
        optionDescription.setFormat(Paths.font('funny.ttf'), 28, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        optionDescription.cameras = [fuckYou];
        add(optionDescription);

        resumeButton = new FlxButton(15, 100, 'Resume', function() {
            //FlxG.mouse.visible = false;
            //FlxG.mouse.useSystemCursor = false;
            close();
        });
        resumeButton.cameras = [fuckYou];
        add(resumeButton);

        restartButton = new FlxButton(15, 50 + 100, 'Restart Song', function() {
            restartSong();
        });
        restartButton.cameras = [fuckYou];
        add(restartButton);

        quitButton = new FlxButton(15, 50 + 200, 'Exit to Menu', function() {
            PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					if(PlayState.isStoryMode) {
						MusicBeatState.switchState(new StoryMenuState());
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
        });
        quitButton.cameras = [fuckYou];
        add(quitButton);

        botplayCheckbox = new FlxUICheckBox(15, 50 + 250, null, null, 'Botplay enabled?', 200);
        botplayCheckbox.checked = PlayState.instance.cpuControlled;
        botplayCheckbox.callback = toggleBotplay;
        botplayCheckbox.cameras = [fuckYou];
        add(botplayCheckbox);

        trollButton = new FlxUICheckBox(15, botplayCheckbox.y + 50, null, null, 'Are we trollin?', 200);
        trollButton.checked = PlayState.instance.weDoALittleTrollin;
        trollButton.cameras = [fuckYou];
        add(trollButton);
        if (!PlayState.instance.cpuControlled) trollButton.kill();

        difficultyButton = new FlxButton(15, 50 + 150, 'Change Difficulty', function() {
            openSubState(new PauseSubState(x, y, true));
        });
        difficultyButton.cameras = [fuckYou];
        add(difficultyButton);
    }

    function toggleBotplay() {
                    PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.text = 'BOTPLAY';
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
                    if (trollButton != null && trollButton.alive) {
                        trollButton.kill();
                    } else if (trollButton != null && !trollButton.alive) {
                        trollButton.revive();
                    }
    }

    function lmaoNice() {
        PlayState.instance.weDoALittleTrollin = !PlayState.instance.weDoALittleTrollin;
		PlayState.changedDifficulty = true;
		PlayState.instance.botplayTxt.text = '';
		PlayState.instance.botplayTxt.alpha = 1;
		PlayState.instance.botplaySine = 0;
    }

    function restartSong(noTrans:Bool = false) {
        PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
    }
    override function update(elapsed) {
        if (controls.BACK) {
            close();
        }
        if (resumeButton != null) {
            resumeButton.update(elapsed);
        }

        if (restartButton != null) {
            restartButton.update(elapsed);
        }

        if (quitButton != null) {
            quitButton.update(elapsed);
        }

        if (botplayCheckbox != null) {
            botplayCheckbox.update(elapsed);
        }

        if (trollButton != null && trollButton.alive) {
            trollButton.update(elapsed);
        }

        if (difficultyButton != null) {
            difficultyButton.update(elapsed);
        }
    }
}