package editors.soundtrack;

import randomShit.dumb.FunkyBackground;
import randomShit.dumb.SoundtrackMenu.OSTData;
import flixel.FlxG;
import flixel.FlxSprite;
import HealthIcon;
import Alphabet;
import flixel.group.FlxGroup.FlxTypedGroup;
import randomShit.util.HintMessageAsset;
using StringTools;

/**The base editor menu for soundtracks. Can be accessed via Options > Extra, as opposed to the Master Editor Menu.
    
@since March 2022 (Emo Engine 0.2.0)*/
class BaseSoundtrackMenu extends MusicBeatState {
    var grpOptions:FlxTypedGroup<Alphabet>;
    var options:Array<String> = ["Setup New OST Data", "Modify Existing OST Data", "Delete OST Data", "Exit"];
    var curSelected:Int = 0;
    var bg:randomShit.dumb.FunkyBackground;

    public function new() {
        super();
    }

    override function create() {
        bg = new FunkyBackground();
        bg.setColor(0xFF00007F, false);
        add(bg);
        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);
        for (opt in 0...options.length) {
            var optionText = new Alphabet(0, (70 * opt), options[opt], true, false);
            optionText.isMenuItem = true;
            optionText.targetY = opt;
            #if debug
            FlxG.log.notice("Adding option " + opt + " of " + options.length + ": " + options[opt]);
            #end
            grpOptions.add(optionText);
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
            openSelectedMenu();
        }
        if (controls.BACK) {
            MusicBeatState.switchState(new options.OptionsStateExtra()); // TEMP UNTIL I FEEL LIKE ADDING TO MASTER EDITOR MENU!!
        }
        super.update(elapsed);
    }

    function openSelectedMenu() {
        switch (options[curSelected]) {
            case "Setup New OST Data":
                FlxG.sound.play(Paths.sound('errorOops'));
                FlxG.log.warn("This state isn't ready yet. What are you doing, " + Sys.getEnv(#if windows "USERNAME" #else "USER" #end) + "?");
            case "Modify Existing OST Data":
                FlxG.sound.play(Paths.sound('errorOops'));
                FlxG.log.warn("This state isn't ready yet. What are you doing, " + Sys.getEnv(#if windows "USERNAME" #else "USER" #end) + "?");
            case "Delete OST Data":
                FlxG.sound.play(Paths.sound('errorOops'));
                FlxG.log.warn("This state isn't ready yet. What are you doing, " + Sys.getEnv(#if windows "USERNAME" #else "USER" #end) + "?");
            case "Exit":
                MusicBeatState.switchState(new options.OptionsStateExtra());
        }
    }

    function changeSelection(change:Int = 0) {
        curSelected += change;
        if (curSelected < 0) {
            curSelected = options.length - 1;
        } else if (curSelected >= options.length) {
            curSelected = 0;
        }
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
}