package editors.soundtrack;

import randomShit.dumb.SoundtrackMenu.OSTData;
import flixel.FlxG;
import MusicBeatState;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import Alphabet;
import HealthIcon;
import randomShit.util.HintMessageAsset;
import randomShit.dumb.FunkyBackground;
import randomShit.util.DumbUtil;
using StringTools;

/**This state is the basic menu state for adding new soundtrack data. Each option, excluding Exit, opens a substate corresponding to its label.
    
@since March 2022 (Emo Engine 0.2.0)*/
class NewSoundtrackState extends MusicBeatState {
    var bg:FunkyBackground;
    public static var justUpdatedColor:Bool = false;
    var options:Array<String> = [
        "Song name",
        "Default opponent",
        "Default bf",
        "Background color",
        "Exit"
    ];
    var templateData:OSTData = {
        songName: "Tutorial",
        defaultOpponent: "gf",
        defaultBf: "bf",
        songColor: [
            69,
            69,
            69
        ]
    };
    public static var currentData:OSTData;
    var grpOptions:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;

    public function new() {
        super();
        currentData = templateData;
    }

    override function create() {
        bg = new FunkyBackground();
        bg.setColor(DumbUtil.getBgRgbColor(currentData.songColor), false);
        add(bg);
        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);
        for (i in 0...options.length) {
            var optText = new Alphabet(0, (70 * i), options[i], true, false);
            optText.isMenuItem = true;
            optText.targetY = i;
            grpOptions.add(optText);
        }

        changeSelection();
    }

    override function update(elapsed:Float) {
        if (controls.UI_UP_P) {
            changeSelection(-1);
        }
        if (controls.UI_DOWN_P) {
            changeSelection(1);
        }
        if (controls.ACCEPT) {
            openSelectedSubState();
        }
        if (controls.BACK) {
            doExitConfirmation();
        }
        if (justUpdatedColor) {
            justUpdatedColor = false;
            bg.setColor(DumbUtil.getBgRgbColor(currentData.songColor), true, 0.7);
        }
    }

    function changeSelection(change:Int = 0) {
        curSelected += change;
        var bullShit:Int = 0;
        for (item in grpOptions.members) {
            item.targetY = bullShit - curSelected;
            bullShit++;

            item.alpha = 0.6;
            if (item.targetY == 0) {
                item.alpha = 1;
            }
        }
    }

    function openSelectedSubState() {
        switch(options[curSelected]) {
            case "Song name":
                FlxG.sound.play(Paths.sound('errorOops'));
                #if debug FlxG.log.warn("What are you doing, " + Sys.getEnv(#if windows "USERNAME" #else "USER" #end)); #end
            case "Default opponent":
                FlxG.sound.play(Paths.sound('errorOops'));
                #if debug FlxG.log.warn("What are you doing, " + Sys.getEnv(#if windows "USERNAME" #else "USER" #end)); #end
            case "Default bf":
                FlxG.sound.play(Paths.sound('errorOops'));
                #if debug FlxG.log.warn("What are you doing, " + Sys.getEnv(#if windows "USERNAME" #else "USER" #end)); #end
            case "Background color":
                FlxG.sound.play(Paths.sound('errorOops'));
                #if debug FlxG.log.warn("What are you doing, " + Sys.getEnv(#if windows "USERNAME" #else "USER" #end)); #end
            case "Exit":
                doExitConfirmation();
        }
    }

        function doExitConfirmation() {
            if (currentData != templateData) {
                openSubState(new Prompt("Would you like to save your changes?", 0, saveOST, exitState, false, "Yes", "No", "information"));
            } else {
                MusicBeatState.switchState(new editors.soundtrack.BaseSoundtrackMenu());
            }
        }

        function saveOST() {
            trace('wip');
        }

        function exitState() {
            MusicBeatState.switchState(new editors.soundtrack.BaseSoundtrackMenu());
        }
    }