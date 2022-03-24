package;

import randomShit.util.SnowdriftUtil;
import flixel.util.FlxColor;
import ProfileThingy.PrelaunchProfileState;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;
import sys.FileSystem;
import flixel.text.FlxText;
import randomShit.util.CustomRandom;
import flixel.addons.ui.FlxUI;
import flixel.FlxG;
import haxe.Json;
import ProfileThingy.ProfileShit;
import TestProfileState;
import DialogueBoxPsych;
import MusicBeatState;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUICheckBox;
import flixel.ui.FlxButton;
import randomShit.dumb.FunkyBackground;
/**setup wizard thingy*/
class ProfileSetupWizard extends MusicBeatState {
    //var bg:FlxSprite;
    var dumb:DialogueFile;
    var dialogueCount:Int = 0;
    var psychDialogue:DialogueBoxPsych;
    var inDialogue:Bool = false;
    var setupBox:FlxUITabMenu;
    var defaults:String = '{
        "profileName": "Default",
        "playerBirthday": [
            1,
            1
        ],
        "saveName": "default",
        "comment": "amogus",
        "profileIcon": "bf"
    }';
    var basicBitch:ProfileShit;
    var someFunnyDefaultComments:Array<String> = [
        'Insert funny comment here',
        'I like the snow',
        'Dumb boyfriend steal your comment? Buy this sexy cum product to cure!',
        'All your notes are belong to me',
        'Never gonna give you up...',
        'You have been bread loafed. Share this within the next 69 seconds to bread loaf someone else'
    ];

    public function new() {
        super();
        trace('smack my ass like a drum');
        PlayerSettings.init();
        basicBitch = cast Json.parse(defaults);
    }

    override function create() {
        /*bg = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.scrollFactor.set();
        bg.color = 0xFFAACCFF;
        add(bg);*/
        add(new FunkyBackground().setColor(0xFFAACCFF, false));
        FlxG.sound.playMusic(Paths.music('wiiPlay_Menu'));
        inDialogue = true;
        dumb = cast Json.parse(Paths.snowdriftChatter('profileIntro'));
        startDialogue(dumb);
    }
    override function update(elapsed:Float) {
        if (psychDialogue != null) {
            psychDialogue.update(elapsed);
        }
        if (setupBox != null) {
            setupBox.update(elapsed);
        }
        if (FlxG.keys.justPressed.H) {
            dumb = SnowdriftUtil.loadChatter('profileExplan');
            startDialogue(dumb);
        }
    }
    public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
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
                        if (setupBox == null) {
                            makeTheBox();
                        }
                        if (houston) {
                            showConflictUI();
                        }
                    }
                psychDialogue.nextDialogueThing = startNextDialogue;
                psychDialogue.skipDialogueThing = skipDialogue;
                // psychDialogue.cameras = [camHUD];
                add(psychDialogue);
            } else {
                FlxG.log.warn('Your dialogue file is badly formatted!');
                //MusicBeatState.switchState(new options.OptionsState());
            }
        }
        //var dialogueCount:Int = 0;
        function startNextDialogue() {
            dialogueCount++;
        }

        function skipDialogue() {
            //callOnLuas('onSkipDialogue', [dialogueCount]);
            trace('ass');
        }

        function makeTheBox() {
            var tabs = [{name: 'SHIT', label: 'Setup'}];
            setupBox = new FlxUITabMenu(null, tabs, true);
            setupBox.resize(250, 300);
            setupBox.screenCenter();
            add(setupBox);
            makeSetupUI();
        }
        //var conflictBox:FlxUIPopup;
        var conflictedName:String = '';
        function showConflictUI() {
            trace('ass');
            openSubState(new Prompt('A profile with the name of ' + conflictedName + ' already exists on this PC. If you continue, ALL data in the existing profile will be overwritten.\nDo you want to continue?', 1, function() {
                ignoringConflict = true;
                saveProfile(dataToSave);
            }, function() {
                trace('penis');
                //close();
            }, false, 'Continue', 'Cancel', 'warning'));
            //conflictBox.quickSetup('Profile conflict', 'A profile with the name of ' + conflictedName + ' already exists on this PC. If you continue, ALL data in the existing profile will be overwritten.\nDo you want to continue?', ['Continue', 'Cancel']);
            //add(conflictBox);
        }
        var dataToSave:ProfileShit;
        var randomNumber:Int;
        var useNowChecker:FlxUICheckBox;
        var useRightAway:Bool = false;
        function makeSetupUI() {
            var tab_group = new FlxUI(null, setupBox);
            tab_group.name = 'SHIT';

            var profileNameInputter:FlxUIInputText = new FlxUIInputText(10, 50, 150, basicBitch.profileName, 8);

            var bdayMonthInputter:FlxUIInputText = new FlxUIInputText(10, profileNameInputter.y + 30, 50, Std.string(basicBitch.playerBirthday[0]), 8);
            var bdayDateInputter:FlxUIInputText = new FlxUIInputText(bdayMonthInputter.x + 100, bdayMonthInputter.y, 50, Std.string(basicBitch.playerBirthday[1]), 8);

            var saveNameInputter:FlxUIInputText = new FlxUIInputText(10, bdayDateInputter.y + 30, 150, basicBitch.saveName, 8);

            var commentInputter:FlxUIInputText = new FlxUIInputText(10, saveNameInputter.y + 30, 150, basicBitch.comment, 8);
            var profileIconInputter:FlxUIInputText = new FlxUIInputText(10, commentInputter.y + 30, 150, basicBitch.profileIcon, 8);
            var saveButton:FlxButton = new FlxButton(commentInputter.getGraphicMidpoint().x, commentInputter.y + 100, 'Done', function() {
                randomNumber = CustomRandom.int(0, someFunnyDefaultComments.length - 1);
                if (commentInputter.text.length >= 1) {
                    dataToSave = {
                    "profileName": profileNameInputter.text,
                    "playerBirthday":[ 
                        bdayMonthInputter.text,
                        bdayDateInputter.text
                    ],
                    "saveName": saveNameInputter.text,
                    "comment": commentInputter.text,
                    "profileIcon": profileIconInputter.text
                };
            } else {
                dataToSave = {
                    "profileName": profileNameInputter.text,
                    "playerBirthday":[ 
                        bdayMonthInputter.text,
                        bdayDateInputter.text
                    ],
                    "saveName": saveNameInputter.text,
                    "comment": someFunnyDefaultComments[randomNumber],
                    "profileIcon": profileIconInputter.text
                };
            }
                trace(dataToSave);
                saveProfile(dataToSave);
            });
            useNowChecker = new FlxUICheckBox(saveButton.x, saveButton.y - 30, null, null, 'Use right away?', 100, null, function() {
                useRightAway = !useRightAway;
                trace('Using after save: ' + useRightAway);
            });
            useNowChecker.checked = useRightAway;
            tab_group.add(useNowChecker);

            tab_group.add(new FlxText(10, profileNameInputter.y - 18, 0, 'Profile name', 8));
            tab_group.add(new FlxText(10, bdayMonthInputter.y - 18, 0, 'Birthday', 8));
            tab_group.add(new FlxText(10, saveNameInputter.y - 18, 0, 'Save name', 8));
            tab_group.add(new FlxText(10, commentInputter.y - 18, 0, 'Comment', 8));
            tab_group.add(new FlxText(10, profileIconInputter.y - 18, 0, 'Profile icon', 8));
            tab_group.add(profileNameInputter);
            tab_group.add(bdayMonthInputter);
            tab_group.add(bdayDateInputter);
            tab_group.add(saveNameInputter);
            tab_group.add(commentInputter);
            tab_group.add(profileIconInputter);
            tab_group.add(saveButton);
            setupBox.addGroup(tab_group);
        }
        var houston:Bool = false;
        var newThing:FlxSave;
        var ignoringConflict:Bool = false;
        function saveProfile(profile:ProfileShit) {
            var hhhhhh = profile;
            if (FileSystem.exists('profiles/' + hhhhhh.profileName + '.json') && !ignoringConflict) {
                trace('MUST ASK IF WE WILL OVERWRITE!');
                houston = true; //houston, we've got a problem
                conflictedName = hhhhhh.profileName;
                dumb = cast Json.parse(Paths.snowdriftChatter('profileConflict'));
                startDialogue(dumb);
            } else {
                //sys.io.File.write('profiles/' + hhhhhh.profileName + '.json'); // i might move these to a new util soon. lmao
                //sys.io.File.saveContent('profiles/' + hhhhhh.profileName + '.json', Json.stringify(hhhhhh, "\t"));
                randomShit.util.ProfileUtil.saveNewProfile(hhhhhh, hhhhhh.profileName);
                newThing = new FlxSave();
                newThing.bind(hhhhhh.saveName, 'fridayNightBrocken');
                trace(newThing);
                if (ignoringConflict) {
                    newThing.erase();
                    newThing.bind(hhhhhh.saveName, 'fridayNightBrocken');
                }
                newThing.data.profileName = hhhhhh.profileName;
                newThing.data.playerBirthday = hhhhhh.playerBirthday;
                newThing.data.saveName = hhhhhh.saveName;
                newThing.data.comment = hhhhhh.comment;
                trace(newThing.data);
                if (!useRightAway) {
                    new FlxTimer().start(0.7, function(tmr:FlxTimer)
                    {
                        FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
                        {
                            FlxG.switchState(new PrelaunchProfileState());
                        });
                    });
                } else {
                    new FlxTimer().start(0.7, function(tmr:FlxTimer) {
                        FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {
                            FlxG.save.bind(hhhhhh.profileName, 'fridayNightBrocken');
                            FlxG.switchState(new TitleState());
                        });
                    });
                }
            }
        }
}