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
    var yourChars:FavouriteCharList;
    var yourFavData:ProfileFavourite;
    var charList:FlxTypedGroup<Alphabet>;
    var charNames:Array<String> = [];
    var Icons:Array<HealthIcon> = [];
    var Icons_String:Array<String> = [];
    var checkArray:Array<CheckboxThingie> = [];

    public function new() {
        super();
        // LEFTOVER FROM char STATE WeekData.reloadWeekFiles(false);
        yourFavData = FavUtil.getFavs();
        yourChars = yourFavData.favouriteChars;
        charNames = DumbUtil.getCharList();
        Icons_String = DumbUtil.getHealthIcons();
    }

    override function create() {
        bg = new FunkyBackground();
        bg.setColor(0xFF696969, false);
        add(bg);
        charList = new FlxTypedGroup<Alphabet>();
        add(charList);
        for (char in 0...charNames.length) {
            /*var checker:CheckboxThingie = new CheckboxThingie(0, (70 * char), yourchars.contains(charNames[char]));
            add(checker);
            checkArray.push(checker); */
            var sEntry = new Alphabet(0, (70 * char) + 30, charNames[char], true, false);
                sEntry.isMenuItem = true;
                sEntry.targetY = char;
                //checker.sprTracker = sEntry;

                charList.add(sEntry);

                var icon:HealthIcon = new HealthIcon(Icons_String[char]);
                icon.sprTracker = sEntry;

                Icons.push(icon);
                add(icon);
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
            openSubState(new profile.subStates.FCSubstate(charNames[curSelected]));
        }
        if (controls.RESET) {
            openSubState(new Prompt("Are you sure you want to reset your favourite characters? This is an irreversible action!", 1, resetFavchars, null, false, 'Reset', 'Cancel', 'xpExclam'));
        }
        if (controls.BACK) {
            openSubState(new Prompt("Would you like to save your changes?", 0, saveData, exitWithoutSaving, false, 'Yes', 'No', 'information'));
        }
    }

    /*function setFavchar() {
        if (yourchars.contains(charNames[curSelected])) {
            yourchars.remove(charNames[curSelected]);
            checkArray[curSelected].daValue = yourchars.contains(charNames[curSelected]);
        } else {
            yourchars.push(charNames[curSelected]);
            checkArray[curSelected].daValue = yourChars.contains(charNames[curSelected]);
        }
    }*/

    function resetFavchars() {
        yourChars.any = [];
        yourChars.bf = [];
        yourChars.gf = [];
        yourChars.opponent = [];
        //e
        FavUtil.setFavs(yourFavData.favouriteSongs, yourChars);
        MusicBeatState.resetState();
    }

    function exitWithoutSaving() {
        LoadingState.loadAndSwitchState(new ProfileFavouriteMenu());
    }

    function saveData() {
        FavUtil.setFavs(yourFavData.favouriteSongs, yourChars);
        LoadingState.loadAndSwitchState(new ProfileFavouriteMenu());
    }
    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected += change;
        if (curSelected < 0) {
            curSelected = charNames.length - 1;
        }
        if (curSelected >= charNames.length) {
            curSelected = 0;
        }

        for (i in 0...Icons.length)
            {
                Icons[i].alpha = 0.6;
            }
            for (i in 0...checkArray.length) {
                checkArray[i].alpha = 0.6;
            }
    
            Icons[curSelected].alpha = 1;
            //checkArray[curSelected].alpha = 1;
            var bullShit:Int = 0;
            for (item in charList.members)
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