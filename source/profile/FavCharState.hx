package profile;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import profile.FavUtil;
import randomShit.util.DumbUtil;
import CheckboxThingie;
import Alphabet;
import HealthIcon;
import randomShit.dumb.FunnyReferences;
import randomShit.dumb.FunkyBackground;
import randomShit.util.HintMessageAsset;

using StringTools;

/**Allows you to set up your favourite characters. These can be separated into Opponent, BF, and GF characters, or put into an "Any" category!
    @since March 2022 (Emo Engine 0.1.2)*/
class FavCharState extends MusicBeatState {
    var bg:FunkyBackground;
    var options:Array<String> = [
        'Any',
        'BF',
        'GF',
        'Opponent',
        'Reset',
        'Done'
    ];
    var grpOpts:FlxTypedGroup<Alphabet>;

    public function new() {
        super();
        // LEFTOVER FROM char STATE WeekData.reloadWeekFiles(false);
    }

    override function create() {
        bg = new FunkyBackground();
        bg.setColor(0xFF696969, false);
        add(bg);
        grpOpts = new FlxTypedGroup<Alphabet>();
        add(grpOpts);
        for (i in 0...options.length) {
            var opt:Alphabet = new Alphabet(0, (70 * i), options[i], true, false);
            opt.isMenuItem = true;
            opt.targetY = i;
            grpOpts.add(opt);
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.UI_UP_P) {
            changeSelection(-1);
        }
        if (controls.UI_DOWN_P) {
            changeSelection(1);
        }
        if (controls.ACCEPT) {
            trace('penis');
            openSelectedSubstate();
        }
        if (controls.BACK) {
            LoadingState.loadAndSwitchState(new profile.ProfileFavouriteMenu());
        }
    }

    function openSelectedSubstate() {
        switch (options[curSelected]) {
            case 'Any':
                openSubState(new profile.subStates.FCAny());
            case 'BF':
                openSubState(new profile.subStates.FavBFChar());
            case 'GF':
                openSubState(new profile.subStates.FavGFChar());
            case 'Opponent':
                openSubState(new profile.subStates.FavOpponChar());
            case 'Reset':
                trace('wip');
            case 'Done':
                LoadingState.loadAndSwitchState(new profile.ProfileFavouriteMenu());
        }
    }
    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected += change;
        if (curSelected < 0) {
            curSelected = options.length - 1;
        }
        if (curSelected >= options.length) {
            curSelected = 0;
        }

            var bullShit:Int = 0;
            for (item in grpOpts.members)
                {
                    item.targetY = bullShit - curSelected;
                    bullShit++;
        
                    item.alpha = 0.6;
                    // item.setGraphicSize(Std.int(item.width * 0.8));
        
                    if (item.targetY == 0)
                    {
                        item.alpha = 1;
                        // item.setGraphicSize(Std.int(item.width));
                    }
                }
    }

	var curSelected:Int = 0;
}