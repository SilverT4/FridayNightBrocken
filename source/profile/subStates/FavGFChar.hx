package profile.subStates;

import Character;
import HealthIcon;
import Alphabet;
import CheckboxThingie;
import randomShit.util.HintMessageAsset;
import randomShit.util.DumbUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import MusicBeatSubstate;
import profile.FavUtil;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import Prompt;
using StringTools;

/**This allows you to set a character as a favourite to appear in the GF category.
@since March 2022 (Emo Engine 0.1.2)*/
class FavGFChar extends MusicBeatSubstate {
    var curList:Array<String> = [];
    var newList:Array<String> = [];
    var charList:FlxTypedGroup<Alphabet>;
    var nameList:Array<String> = [];
    var parsed_list:Array<CharacterFile> = []; // FOR THE PURPOSE OF GETTING HEALTHBAR COLOURS!!
    var iconList:Array<String> = [];
    var iconArray:Array<HealthIcon> = [];
    var checkArray:Array<CheckboxThingie> = [];
    var yourFavs:ProfileFavourite;
    var bg:FlxSprite;
    var colourTween:FlxTween;
    var intendedColour:Int = 0x69696969;
    public function new() {
        yourFavs = FavUtil.getFavs();
        curList = yourFavs.favouriteChars.gf;
        newList = curList;
        nameList = DumbUtil.getCharList();
        iconList = DumbUtil.getIcons(nameList);
        parsed_list = DumbUtil.parseChars(nameList);
        super();
    }

    override function create() {
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x69696969);
        add(bg);
        charList = new FlxTypedGroup<Alphabet>();
        add(charList);
        for (char in 0...nameList.length) {
            var checker:CheckboxThingie = new CheckboxThingie(0, (70 * char), (curList.contains(nameList[char]) || newList.contains(nameList[char])));
            var nameEntry:Alphabet = new Alphabet(0, (70 * char) + 30, nameList[char], true, false);
            nameEntry.isMenuItem = true;
            nameEntry.targetY = char;
            charList.add(nameEntry);
            add(checker);
            checkArray.push(checker);
            var icon:HealthIcon = new HealthIcon(iconList[char]);
            icon.sprTracker = nameEntry;
            checker.sprTracker = icon;
            add(icon);
            iconArray.push(icon);
        }
        doBgColorTween(nameList[0]);
        changeSelection(0);
    }

    function doBgColorTween(chara:String) {
        var newColour = DumbUtil.getBgRgbColor_Sub(parsed_list[nameList.indexOf(chara)].healthbar_colors);
        if (newColour != intendedColour) {
            intendedColour = newColour;
            colourTween = FlxTween.color(bg, 0.8, bg.color, intendedColour);
        } else {
            //no tween
            trace('e');
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK) {
            doCloseThings();
        }

        if (controls.ACCEPT) {
            doAcceptThings();
        }

        if (controls.UI_UP_P) {
            changeSelection(-1);
        }

        if (controls.UI_DOWN_P) {
            changeSelection(1);
        }

        if (FlxG.keys.justPressed.K) {
            saveChanges();
        }
    }

    function doCloseThings() {
        // check newList against curList
        if (newList != curList) {
            openSubState(new Prompt("Would you like to save your changes?", 0, function() {
                saveChanges();
                close();
            }, function() {
                close();
            }, false, 'Save', 'No', 'information'));
        } else {
            close();
        }
    }
    function saveChanges() {
        yourFavs.favouriteChars.gf = newList;
        FavUtil.setFavs(yourFavs.favouriteSongs, yourFavs.favouriteChars);
    }
    function doAcceptThings() {
        if (curList.contains(nameList[curSelected]) || newList.contains(nameList[curSelected])) {
            newList.remove(nameList[curSelected]);
            checkArray[curSelected].daValue = newList.contains(nameList[curSelected]);
        } else {
            newList.push(nameList[curSelected]);
            checkArray[curSelected].daValue = newList.contains(nameList[curSelected]);
        }
    }
    var curSelected:Int = 0;
    function changeSelection(change:Int) {
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
            for (i in 0...checkArray.length) {
                checkArray[i].alpha = 0.6;
            }
    
            iconArray[curSelected].alpha = 1;
            checkArray[curSelected].alpha = 1;
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
}