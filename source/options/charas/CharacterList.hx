package options.charas;

import flixel.util.FlxColor;
import randomShit.util.DevinsFileUtils;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import randomShit.dumb.FunkyBackground;
import randomShit.util.DumbUtil;
import randomShit.util.HintMessageAsset;
import HealthIcon;
import Alphabet;
import MusicBeatState;
import Character.CharacterFile as SusFile; // so i have the char data i need!!
import openfl.system.Capabilities as SusScreenShit;
using StringTools;

/**A character list state. Uses the same menu layout as Freeplay, but displays characters and allows you to test their animations.
    
@since March 2022 (Emo Engine 0.1.2)*/
class CharacterList extends MusicBeatState {
    //penis
    var charList:Array<String> = [];
    var iconArray:Array<HealthIcon> = [];
    var nameList:FlxTypedGroup<Alphabet>;
    var PARSED_LIST:Array<SusFile> = [];
    var colorArray:Array<FlxColor> = [];
    var bg:FunkyBackground;
    var hint:HintMessageAsset;
    static inline final DEFAULT_COLOR:FlxColor = 0xFF069420;
    public function new() {
        charList = DumbUtil.getAllChars();
        super();
    }

    override function create() {
        bg = new FunkyBackground();
        bg.setColor(DEFAULT_COLOR, false);
        add(bg);
        nameList = new FlxTypedGroup<Alphabet>();
        add(nameList);
        for (char in 0...charList.length) {
            var nameEntry = new Alphabet(0, (70 * char) + 30, charList[char], true, false);
                nameEntry.isMenuItem = true;
                nameEntry.targetY = char;

                nameList.add(nameEntry);

                PARSED_LIST.push(DumbUtil.getCharFile(charList[char]));

                var icon:HealthIcon = new HealthIcon(PARSED_LIST[char].healthicon);
                icon.sprTracker = nameEntry;

                iconArray.push(icon);
                add(icon);

                var menuColor:FlxColor = DumbUtil.getFromRGB(PARSED_LIST[char].healthbar_colors);
                colorArray.push(menuColor);
        }

        bg.setColor(colorArray[0], true, 5);

        hint = new HintMessageAsset("Select a character!", 24, ClientPrefs.smallScreenFix);
        add(hint);
        add(hint.ADD_ME);
    }

    override function update(elapsed:Float) {
        if (controls.UI_UP_P) {
            changeSelection(-1);
        }

        if (controls.UI_DOWN_P) {
            changeSelection(1);
        }

        if (controls.ACCEPT) {
            LoadingState.loadAndSwitchState(new CharacterTester(charList[curSelected]));
        }

        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            LoadingState.loadAndSwitchState(new options.OptionsStateExtra());
        }

        super.update(elapsed);
    }
    var curSelected:Int = 0;
    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected += change;
        if (curSelected < 0) {
            curSelected = nameList.length - 1;
        }
        if (curSelected >= nameList.length) {
            curSelected = 0;
        }

        for (i in 0...iconArray.length)
            {
                iconArray[i].alpha = 0.6;
            }
    
            iconArray[curSelected].alpha = 1;
            var bullShit:Int = 0;
            for (item in nameList.members)
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
            bg.setColor(colorArray[curSelected], true, 1.2);
    }
}