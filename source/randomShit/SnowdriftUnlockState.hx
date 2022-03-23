package randomShit;

import randomShit.util.DumbUtil;
import randomShit.util.DevinsFileUtils;
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
    public static var celebratingBirthday:Bool = false; // FOR WHEN THE PLAYER STARTS THIS ON THEIR BIRTHDAY!!

    public function new(birthday:Bool = false) {
        super();
        if (birthday) celebratingBirthday = true;
    }

    override function create() {
        if (!celebratingBirthday) doSaveCheck();
        else {
            if (Paths.fileExists(Paths.snowdriftChatter('birthday'), openfl.utils.AssetType.TEXT, true)) loadAndReplaceInBDayDia();
            else loadBdayDiaFromHardcode();
        }
    }

    function loadAndReplaceInBDayDia() {
        var bdayDialogue:DialogueFile = DumbUtil.parseSnowdriftChatter(Paths.snowdriftChatter('birthday'));

    }

    function loadBdayDiaFromHardcode() {
        var playerName = TitleState.currentProfile.profileName;
        var bdayDialogue:DialogueFile = {
            dialogue: [
                {
                    portrait: 'snowdrift',
                    expression: 'excited',
                    text: "Hey there! What can I do for you today?",
                    boxState: "normal",
                    speed: 0.05
                }
            ],
            dialogueMusic: Paths.music('DaveDialogue'),
            musicFadeOut: false
        }; // so i have smth
        var diaLines:Array<String> = [
            "Hang on...",
            "Oh hey! " + playerName + ", it's you!",
            "I was hoping you'd be able to stop by today!",
            "Today's your birthday, right?",
            "Well, happy birthday!",
            "I don't have much to offer, but...",
            "How'd you like to rap battle against me?",
            "I'll let you pick the song."
        ];
        var diaExpress:Array<String> = [
            "normal",
            "excited",
            "excited",
            "excited",
            "excited",
            "awkward",
            "excited",
            "excited"
        ];
        for (i in 0...diaLines.length) {
            var jejje = {
                portrait: 'snowdrift',
                expression: diaExpress[i],
                text: diaLines[i],
                boxState: "normal",
                speed: 0.05
            };
        }
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