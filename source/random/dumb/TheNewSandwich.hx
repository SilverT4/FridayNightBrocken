package random.dumb;

import flixel.util.FlxTimer;
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
import PlayState;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUI;
import flixel.ui.FlxBar;
import Conductor;
import MusicBeatSubstate;

using StringTools;
/**
    newer version of FunnySandwich
    @author devin503
    @since March 2022 (Emo Engine 0.1.2)
    */
class TheNewSandwich extends MusicBeatSubstate {
    /**The main UI box.*/
    var PauseUI_Box:FlxUITabMenu;
    var SongControls:FlxUI;
    var CharacterControls:FlxUI;
    var DifficultyControls:FlxUI;
    var sandCam:FlxCamera;
    var optionDesc:FlxText;
    var optionDescriptions:Map<String, String> = [
        'NONE' => "Hover over an option to see its description!",
        'Resume' => "Exits this menu and resumes the song.",
        'Are we trollin?' => "Toggle the troll function of Emo Engine's botplay.",
        'Toggle Botplay' => "Toggle botplay",
        'Restart Song' => "Restarts the song. Simple as that.",
        'Charting Mode' => "Opens the chart editor.",
        'Exit to Menu' => "Quits the song and returns you to either the story menu or the freeplay menu.",
        'difficulty' => "Change the difficulty of the song. Click the RESET button to switch.",
        'RESET SONG' => "Restarts the song with the selected difficulty."
    ];
    var optionItems:Array<Dynamic> = []; // THIS WILL BE USED IN UPDATE.
    public function new(x:Float, y:Float) {
        super();
        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
            if (!FlxG.mouse.useSystemCursor) FlxG.mouse.useSystemCursor = true;
        }
        sandCam = new FlxCamera();
        sandCam.bgColor.alpha = 0;
        FlxG.cameras.add(sandCam);
        var bg:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 0, 0, 128));
        bg.cameras = [sandCam];
        add(bg);
        var descBG:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, 30, FlxColor.fromRGB(0, 0, 0, 128));
        descBG.cameras = [sandCam];
        add(descBG);
        optionDesc = new FlxText(1, 1, FlxG.width - 1, 'Hover over an option to see its description!', 8);
        optionDesc.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        optionDesc.cameras = [sandCam];
        add(optionDesc);
    }

    override function create() {
        var tabs = [
            { name: "Song", label: "Song" },
            { name: "Character", label: "Character" },
            { name: "Difficulty", label: "Difficulty" }
        ];
        PauseUI_Box = new FlxUITabMenu(null, tabs);
        PauseUI_Box.resize(FlxG.width - 350, FlxG.height - 150);
        PauseUI_Box.setPosition(350, 150);
        PauseUI_Box.updateHitbox();
        PauseUI_Box.cameras = [sandCam];
        add(PauseUI_Box);
        PauseUI_Box.selected_tab_id = 'song';
        addSongUI();
        //addCharUI();
        //addDiffUI();
    }
    #if debug
    var mouseInfoBg:FlxSprite;
    var mouseInfoText:FlxText;
    var mouseInfoOn:Bool = false;
    function showMouseInfo() {
        if (mouseInfoBg == null) {
            mouseInfoBg = new FlxSprite(0);
        }
        if (mouseInfoText == null) {
            mouseInfoText = new FlxText(0, 0, 0, 'Mouse X: ' + FlxG.mouse.x + '\nMouse Y: ' + FlxG.mouse.y, 8);
            mouseInfoText.scrollFactor.set(1, 1);
            mouseInfoText.setFormat("Nintendo DS BIOS Regular", 16, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            mouseInfoBg.makeGraphic(Std.int(mouseInfoText.width), Std.int(mouseInfoText.height), FlxColor.fromRGB(0, 0, 0, 128));
            mouseInfoBg.setPosition(mouseInfoText.x, mouseInfoText.y);
            mouseInfoBg.cameras = [sandCam];
            mouseInfoText.cameras = [sandCam];
        }
        add(mouseInfoBg);
        add(mouseInfoText);
        if (mouseInfoOn) {
            if (!mouseInfoBg.alive) mouseInfoBg.revive();
            if (!mouseInfoText.alive) mouseInfoText.revive();
        } else {
            if (mouseInfoBg.alive) mouseInfoBg.kill();
            if (mouseInfoText.alive) mouseInfoText.kill();
        }
    }
    #end
    override function update(elapsed:Float) {
        if (optionDesc != null) {
            if (optionItems.length > 1) {
                for (optionItem in optionItems) {
                    if (optionItem is FlxButton) {
                        if (FlxG.mouse.overlaps(optionItem)) {
                            if (optionDescriptions[optionItem.label.text] != null) optionDesc.text = optionDescriptions[optionItem.label.text];
                        }
                        break;
                    } else if (optionItem is FlxUIDropDownMenuCustom) {
                        if (FlxG.mouse.overlaps(optionItem)) {
                            if (optionDescriptions['difficulty'] != null) optionDesc.text = optionDescriptions['difficulty'];
                        }// ONLY UIDROPDOWNMENUCUSTOM ATM IS GONNA BE DIFFICULTY, THIS'LL CHANGE LATER!
                        break;
                    } else if (optionItem is FlxUICheckBox) {
                        if (FlxG.mouse.overlaps(optionItem)) {
                            if (optionDescriptions[optionItem.getLabel().text] != null) optionDesc.text = optionDescriptions[optionItem.getLabel().text];
                        }
                        break;
                    } else {
                        optionDesc.text = optionDescriptions['NONE'];
                    }
                }
            }
        }
        if (PauseUI_Box != null) PauseUI_Box.update(elapsed);
        if (textStuff.length > 1) {
            for (text in textStuff) {
                if (text != null) {
                    text.update(elapsed);
                    if (!text.isOnScreen(sandCam)) text.x = 20;
                }
            }
        }
        if (controls.BACK) resumeSong();
        #if debug
        if (FlxG.keys.justPressed.M) {
            mouseInfoOn = !mouseInfoOn;
        }
        if (mouseInfoOn) {
            if (mouseInfoBg != null) {
                mouseInfoBg.setPosition(mouseInfoText.x, mouseInfoText.y);
                mouseInfoBg.setGraphicSize(Std.int(mouseInfoText.width), Std.int(mouseInfoText.height));
            }
            if (mouseInfoText != null) {
                mouseInfoText.setPosition(FlxG.mouse.x - 15, FlxG.mouse.y - 15);
                mouseInfoText.text = 'Mouse X: ' + FlxG.mouse.x + '\nMouse Y: ' + FlxG.mouse.y;
            }
        }
        #end

        super.update(elapsed);
    }
    var SongNameText:FlxText;
    var SongDifficultyText:FlxText;
    var BlueballText:FlxText;
    var trollButton:FlxUICheckBox;
    var textStuff:Array<FlxText> = [];
    function addSongUI() {
        SongControls = new FlxUI(null, PauseUI_Box);
        SongControls.name = 'Song';
        SongNameText = new FlxText(20, 15, 0, "", 32);
        SongNameText.text += PlayState.SONG.song;
        SongNameText.scrollFactor.set();
        SongNameText.setFormat("VCR OSD Mono", 32);
        SongNameText.cameras = [sandCam];
        add(SongNameText);
        SongDifficultyText = new FlxText(20, 15 + 32, 0, "", 32);
        SongDifficultyText.text += CoolUtil.difficultyString();
        SongDifficultyText.scrollFactor.set();
        SongDifficultyText.setFormat("VCR OSD Mono", 32);
        SongDifficultyText.cameras = [sandCam];
        add(SongDifficultyText);
        BlueballText = new FlxText(20, 15 + 64, 0, "", 32);
        BlueballText.text = "Blueballed: " + PlayState.deathCounter;
        BlueballText.scrollFactor.set();
        BlueballText.setFormat("VCR OSD Mono", 32);
        BlueballText.cameras = [sandCam];
        add(BlueballText);
        textStuff = [SongNameText, SongDifficultyText, BlueballText];
        var resumeButton = new FlxButton(15, 30, 'Resume', resumeSong);
        var resetButton = new FlxButton(15, resumeButton.y + 30, 'Restart Song', restartSong);
        var chartButton = new FlxButton(resetButton.x + 210, resumeButton.y, 'Charting Mode', openChartEditor);
        var exitButton = new FlxButton(resetButton.x + 210, resetButton.y, 'Exit to Menu', exitSong);
        trollButton = new FlxUICheckBox(15, 169, null, null, 'Are we trollin?', 200, null, toggleTroll);
        var botplayChecky:FlxUICheckBox = new FlxUICheckBox(15, trollButton.y - 30, null, null, 'Toggle botplay', 200, null, toggleBotplay);
        botplayChecky.checked = PlayState.instance.cpuControlled;
        trollButton.checked = PlayState.instance.weDoALittleTrollin;
        optionItems.push(trollButton);
        optionItems.push(resumeButton);
        optionItems.push(resetButton);
        optionItems.push(chartButton);
        optionItems.push(exitButton);
        optionItems.push(botplayChecky);

        SongControls.add(resumeButton);
        SongControls.add(resetButton);
        SongControls.add(chartButton);
        SongControls.add(exitButton);
        SongControls.add(trollButton);
        SongControls.add(botplayChecky);
        PauseUI_Box.addGroup(SongControls);
        PauseUI_Box.screenCenter(); // DO IT AGAIN.
    }

    function resumeSong() {
        close();
    }
    function exitSong() {
        if (PlayState.dunFuckedUpNow) {
            killYourMom();
        } else {
            PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
            if(PlayState.isStoryMode) {
                MusicBeatState.switchState(new StoryMenuState());
            } else {
                MusicBeatState.switchState(new FreeplayState());
            }
            PlayState.changedDifficulty = false;
            PlayState.chartingMode = false;
        }
    }
    function restartSong() {
        if (!PlayState.dunFuckedUpNow) {
            PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		/*if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{ */
			MusicBeatState.resetState();
		} else {
            killYourMom();
        }
    }
    function openChartEditor() {
        if (PlayState.dunFuckedUpNow) {
            killYourMom();
        } else {
            PlayState.instance.openChartEditor();
        }
    }
    /**PLEASE DO NOT ACTUALLY KILL YOUR MOM!!*/
    function killYourMom() {
        FlxG.sound.play(Paths.sound('daFunniWell'), 1, false, null, true, function() {
            PlayState.instance.addCharacterToList('devan', 0);
            PlayState.instance.health = 0;
            close();
        });
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

    function toggleTroll() {
        PlayState.instance.weDoALittleTrollin = !PlayState.instance.weDoALittleTrollin;
		PlayState.changedDifficulty = true;
		if (!PlayState.instance.weDoALittleTrollin) PlayState.instance.botplayTxt.text = 'BOTPLAY' else PlayState.instance.botplayTxt.text = '';
		PlayState.instance.botplayTxt.alpha = 1;
		PlayState.instance.botplaySine = 0;
    }
}