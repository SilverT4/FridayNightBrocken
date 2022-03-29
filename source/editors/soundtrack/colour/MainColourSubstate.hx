package editors.soundtrack.colour;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import randomShit.util.HintMessageAsset;
import flixel.text.FlxText;
import Alphabet;
import flixel.group.FlxGroup.FlxTypedGroup;
import editors.soundtrack.NewSoundtrackState;
import editors.soundtrack.colour.*;
import randomShit.dumb.SoundtrackMenu.SongColorInfo;
using StringTools;

/**The main colour menu of the soundtrack editors.
    @since March 2022 (Emo Engine 0.2.0)*/
class MainColourSubstate extends MusicBeatSubstate {
    var curColor:SongColorInfo;
    public static var newColor:SongColorInfo;
    var options:Array<String> = ["Red", "Green", "Blue", "Copy from icon", "Reset", "Done"];
    var grpOptions:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var bg:FlxSprite;

    public function new(CurrentColor:SongColorInfo) {
        curColor = CurrentColor;
        newColor = CurrentColor;
        super();
    }

    override function create() {
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x69696969);
        add(bg);
        grpOptions = new FlxTypedGroup<Alphabet>();
        add(grpOptions);
        for (opt in 0...options.length) {
            var optionText = new Alphabet(0, (70 * opt), options[opt], true, false);
            optionText.isMenuItem = true;
            optionText.targetY = opt;
            grpOptions.add(optionText);
        }

        changeSelection();
        ready = true;
    }
    var ready:Bool = false;
    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound("scrollMenu"));
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

    override function update(elapsed:Float) {
        if (ready) {
            if (controls.UI_UP_P) {
            changeSelection(-1);
        }
        if (controls.UI_DOWN_P) {
            changeSelection(1);
        }
        if (controls.ACCEPT) {
            doHighlighted();
        }
        if (controls.BACK) {
            doCloseChecks();
        }
    }
        super.update(elapsed);
    }

    function doCloseChecks() {
        if (NewSoundtrackState.currentData != null) {
            NewSoundtrackState.currentData.songColorInfo = newColor;
        }
        close();
    }

    function doHighlighted() {
        switch (options[curSelected]) {
            case "Red":
                openSubState(new RedSubState());
            case "Green":
                // openSubState(new GreenSubState());
            case "Blue":
                // openSubState(new BlueSubState());
            case "Copy from icon":
                // openSubState(new CopyIconColour());
            case "Reset":
                newColor = curColor;
                trace("reset!");
            case "Done":
                doCloseChecks();
        }
    }
}