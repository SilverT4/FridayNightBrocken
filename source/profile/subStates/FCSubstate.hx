package profile.subStates;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import Alphabet;
import CheckboxThingie;
import profile.FavUtil;
import randomShit.util.HintMessageAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using StringTools;

/**This state allows you to modify the lists you have a character set as favourite for.
    @since March 2022 (Emo Engine 0.1.2)*/
class FCSubstate extends MusicBeatSubstate {
    var yourChars:FavouriteCharList;
    var theChar:String;
    var anyList:Array<String>;
    var bfList:Array<String>;
    var gfList:Array<String>;
    var oppList:Array<String>;
    var bg:FlxSprite;
    var checkList:Array<CheckboxThingie> = [];
    var typeList:FlxTypedGroup<Alphabet>;

    public function new(CharacterName:String) {
        super();
        theChar = CharacterName;
        yourChars = FlxG.save.data.profileFavourites.favouriteChars;
        anyList = yourChars.any;
        bfList = yourChars.bf;
        gfList = yourChars.gf;
        oppList = yourChars.opponent;
    }

    var checker_Any:CheckboxThingie;
    var checker_BF:CheckboxThingie;
    var checker_GF:CheckboxThingie;
    var checker_Oppon:CheckboxThingie;
    override function create() {
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x69000000);
        add(bg);
        typeList = new FlxTypedGroup<Alphabet>();
        add(typeList);
        var shitStuff = [
            'Any',
            'Bf',
            'Gf',
            'Opponent'
        ];
        var dick:Array<Dynamic> = [];
        checker_Any = new CheckboxThingie(0, 70, anyList.contains(theChar));
        var alphabitch:Alphabet = new Alphabet(0, 70, "Any", true, false);
        checker_Any.sprTracker = alphabitch;
        checkList.push(checker_Any);
        checker_BF = new CheckboxThingie(0, 140, bfList.contains(theChar));
        var betaBitch:Alphabet = new Alphabet(0, 140, "Boyfriend", true, false);
        checkList.push(checker_BF);
        dick.push(checker_Any);
        dick.push(alphabitch);
        dick.push(checker_BF);
        dick.push(betaBitch);
        checker_GF = new CheckboxThingie(0, 210, gfList.contains(theChar));
        var cvmBitch:Alphabet = new Alphabet(0, 210, "Girlfriend", true, false);
        checker_GF.sprTracker = cvmBitch;
        dick.push(checker_GF);
        dick.push(cvmBitch);
        checker_Oppon = new CheckboxThingie(0, 280, oppList.contains(theChar));
        var dumBitch:Alphabet = new Alphabet(0, 280, "Opponent", true, false);
        checker_Oppon.sprTracker = dumBitch;
        dick.push(checker_Oppon);
        dick.push(dumBitch);
        typeList.add(alphabitch);
        typeList.add(betaBitch);
        typeList.add(cvmBitch);
        typeList.add(dumBitch);

        for (ass in dick) {
            if (ass is CheckboxThingie) add(ass);
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
        if (controls.BACK) {
            saveChanges();
        }

        if (controls.ACCEPT) {
            doAppropriateAction(curSelected);
        }

        super.update(elapsed);
    }
    function doAppropriateAction(typeSel:Int) {
        switch (typeSel) {
            case 0:
                if (anyList.contains(theChar)) {
                    anyList.remove(theChar);
                    checker_Any.daValue = anyList.contains(theChar);
                } else {
                    if (bfList.contains(theChar)) {
                        doAppropriateAction(1);
                    }
                    if (gfList.contains(theChar)) {
                        doAppropriateAction(2);
                    }
                    if (oppList.contains(theChar)) {
                        doAppropriateAction(3);
                    }
                    anyList.push(theChar);
                    checker_Any.daValue = anyList.contains(theChar);
                }
            case 1:
                if (bfList.contains(theChar)) {
                    bfList.remove(theChar);
                    checker_BF.daValue = bfList.contains(theChar);
                } else {
                    if (anyList.contains(theChar)) {
                        doAppropriateAction(0);
                    }
                    bfList.push(theChar);
                    checker_BF.daValue = bfList.contains(theChar);
                }
            case 2:
                if (gfList.contains(theChar)) {
                    gfList.remove(theChar);
                    checker_GF.daValue = gfList.contains(theChar);
                } else {
                    if (anyList.contains(theChar)) {
                        doAppropriateAction(0);
                    }
                    gfList.push(theChar);
                    checker_GF.daValue = gfList.contains(theChar);
                }
            case 3:
                if (oppList.contains(theChar)) {
                    oppList.remove(theChar);
                    checker_Oppon.daValue = oppList.contains(theChar);
                } else {
                    if (anyList.contains(theChar)) {
                        doAppropriateAction(0);
                    }
                    oppList.push(theChar);
                    checker_Oppon.daValue = oppList.contains(theChar);
                }
        }
    }
    function saveChanges() {
        FlxG.save.data.profileFavourites.favouriteChars = {
            opponent: oppList,
            bf: bfList,
            gf: gfList,
            any: anyList
        }
        close();
    }
    var curSelected:Int = 0;
    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected += change;
        if (curSelected < 0) {
            curSelected = typeList.length - 1;
        }
        if (curSelected >= typeList.length) {
            curSelected = 0;
        }
            for (i in 0...checkList.length) {
                checkList[i].alpha = 0.6;
            }
    
            //Icons[curSelected].alpha = 1;
            //checkArray[curSelected].alpha = 1;
            var bullShit:Int = 0;
            for (item in typeList.members)
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