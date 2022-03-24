package;

import ProfileSetupWizard;
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
        //var eje = new PlayState();
        startDialogue(dialogueJson);
        contAsGuest = new FlxButton(0, 0, 'Continue as Guest', setupGuest);
        contAsGuest.screenCenter();
        contAsGuest.y -= 60;
        add(contAsGuest);
        contAsGuest.kill();
        setupProfile = new FlxButton(0, 0, 'Set Up Profile', goToProfState);
        setupProfile.screenCenter();
        setupProfile.y += 60;
        add(setupProfile);
        setupProfile.kill();
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
    var inDialogue:Bool = false;
    public function startDialogue(dialogueFile:DialogueFile):Void
        {
            // TO DO: Make this more flexible, maybe?
            if(psychDialogue != null) return;
    
            if(dialogueFile.dialogue.length > 0) {
                // inCutscene = true;
                CoolUtil.precacheSound('dialogue', 'shared');
                CoolUtil.precacheSound('dialogueClose', 'shared');
                psychDialogue = new DialogueBoxPsych(dialogueFile);
                psychDialogue.scrollFactor.set();
                    psychDialogue.finishThing = function() {
                        psychDialogue = null;
						inDialogue = false;
                        contAsGuest.revive();
                        setupProfile.revive();
                        // MusicBeatState.switchState(new options.OptionsState());
                    }
                psychDialogue.nextDialogueThing = startNextDialogue;
                psychDialogue.skipDialogueThing = skipDialogue;
                // psychDialogue.cameras = [camHUD];
                add(psychDialogue);
            } else {
                FlxG.log.warn('Your dialogue file is badly formatted!');
            }
        }
        var dialogueCount:Int = 0;
        function startNextDialogue() {
            dialogueCount++;
        }

        function skipDialogue() {
            //callOnLuas('onSkipDialogue', [dialogueCount]);
            trace('ass');
        }
}