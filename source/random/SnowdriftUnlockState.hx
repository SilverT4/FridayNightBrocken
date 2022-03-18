package random;

import random.util.DumbUtil;
import random.util.DevinsFileUtils;
import flixel.FlxG.save as YourSave;
import flixel.FlxSprite;
import Paths;
import MusicBeatState;
import options.SnowdriftStuff;
import options.OptionsStateExtra;
import DialogueBoxPsych;
import LoadingState;

/**For the Snowdrift menu. I want to make it so if you visit them a certain number amount of times, you unlock something new.*/
class SnowdriftUnlockState extends MusicBeatState {
    var unlockedStuff:Array<String> = [];
    var unlockableStuff:Array<String> = ['Guide Mode', 'Snowdrift\'s Note Assets', 'Play as Snowdrift']; // I NEED TO THINK OF MORE!!
    var psychDialogue:DialogueBoxPsych;
    var dialogueJson:DialogueFile;
    var dialoguesToLoad:Array<DialogueFile> = [];

    public function new() {
        super();
    }

    override function create() {
        doSaveCheck();
    }

    function doSaveCheck() {
        if (YourSave.data.snowdriftVisitCount >= 10 && YourSave.data.snowdriftVisitCount < 50) {
            unlockThisThing(10);
        }
        if (YourSave.data.snowdriftVisitCount >= 50 && YourSave.data.snowdriftVisitCount < 100) {
            unlockThisThing(50);
        }
        if (YourSave.data.snowdriftVisitCount >= 100) {
            unlockThisThing(100);
        }

        loadUnlockDialogue();
    }

    function unlockThisThing(VisitCountMin:Int) {
        switch (VisitCountMin) {
            case 10:
                trace('guide unlock');
            case 50:
                trace('note unlock');
            case 100:
                trace('char unlock');
        }
    }

    function loadUnlockDialogue() {
        if (YourSave.data.snowdriftVisitCount >= 50 && !unlockedStuff.contains('Guide Mode')) {
            dialoguesToLoad.push(DumbUtil.parseSnowdriftChatter(Paths.snowdriftChatter('noteUnlock')));
            dialoguesToLoad.push(DumbUtil.parseSnowdriftChatter(Paths.snowdriftChatter(#if debug 'multiUnlock' #else 'possibleCheat' #end)));
            dialoguesToLoad.push(DumbUtil.parseSnowdriftChatter(Paths.snowdriftChatter('guideUnlock')));
        }
    }
}