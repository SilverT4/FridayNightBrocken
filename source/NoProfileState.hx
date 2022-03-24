package;

import ProfileThingy.ProfileSetupWizard;
import flixel.FlxG;
import flixel.ui.FlxButton;
import DialogueBoxPsych;
import randomShit.util.SnowdriftUtil; // new class alert
import randomShit.dumb.FunkyBackground;

/**This state opens if no profiles exist and the player continues to press enter.*/
class NoProfileState extends MusicBeatState {
    public function new() {
        super();
    }
    var psychDialogue:DialogueBoxPsych;
    var dialogueJson:DialogueFile;
    var contAsGuest:FlxButton;
    var setupProfile:FlxButton;
    override function create() {
        add(new FunkyBackground().setColor(0xFFAACCFF, false));
        dialogueJson = SnowdriftUtil.loadChatter('guest');
        var eje = new PlayState();
        eje.startDialogue(dialogueJson);
        contAsGuest = new FlxButton(0, 0, 'Continue as Guest', setupGuest);
        contAsGuest.screenCenter();
        contAsGuest.y -= 60;
        add(contAsGuest);
        setupProfile = new FlxButton(0, 0, 'Set Up Profile', goToProfState);
        setupProfile.screenCenter();
        setupProfile.y += 60;
        add(setupProfile);
    }

    function setupGuest() {
        TitleState.currentProfile = {
            "profileName": "Guest",
            "playerBirthday": randomShit.util.DevinsDateStuff.getTodaysDate(),
            "saveName": "guestProfile",
            "comment": "You're a little rascal.",
            "profileIcon": "bf"
        };
        MusicBeatState.switchState(new TitleState());
    }

    function goToProfState() {
        FlxG.switchState(new ProfileSetupWizard());
    }
}