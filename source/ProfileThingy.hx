package;

import flixel.math.FlxRandom;
import sys.FileSystem;
import haxe.Json;
import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIBar;
import Paths;
import random.util.CustomRandom;
import DialogueBoxPsych;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUIList;
import flixel.addons.ui.FlxUI;

using StringTools;

/**profiles are smth i want to work on to give the player multiple saves idk*/
typedef ProfileShit = {
    var profileName:String;
    var playerBirthday:Array<Int>;
    var saveName:String;
    var comment:String;
}

/**This will be shown at launch ig*/
class PrelaunchProfileState extends FlxState {
    var bg:FlxSprite;
    var itemDescBg:FlxSprite;
    var itemDesc:FlxText;
    var saveListBox:FlxUITabMenu;
    var saveList:FlxUIList;

    public function new() {
        super();
        if (!FlxG.mouse.visible) FlxG.mouse.visible = true;
        FlxG.sound.play(Paths.sound('DSBoot'));
    }

    override function create() {
        if (FlxG.sound.music == null) {
            new FlxTimer().start(5, function(tmr:FlxTimer) {
                FlxG.sound.playMusic(Paths.music('DSClock'), 1);
            });
        }
        bg = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.color = 0xFF0000FF;
        add(bg);
        itemDescBg = new FlxSprite(0).makeGraphic(FlxG.width, 26, FlxColor.fromRGB(0, 0, 0, 128));
        itemDescBg.y = FlxG.height - 26;
        add(itemDescBg);
        itemDesc = new FlxText(0, itemDescBg.y + 4, FlxG.width, 'Select a save above. If you do not see yours, click Create.', 24);
        itemDesc.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(itemDesc);
        var tabs = [
            {name: 'Saves', label: 'Saves'}
        ];
        saveListBox = new FlxUITabMenu(null, tabs, true);
        saveListBox.resize(Std.int(FlxG.width), Std.int(FlxG.height - 26));
        add(saveListBox);
        generateBasicControls();
    }
    var loadButton:FlxButton;
    var eraseButton:FlxButton;
    var createButton:FlxButton;
    function generateBasicControls() {
        trace('sus');
        var tab_group = new FlxUI(null, saveListBox);
        tab_group.name = 'Saves';
        loadButton = new FlxButton(FlxG.width - 128, 20, 'Load this save', loadSave);
        createButton = new FlxButton(loadButton.x, loadButton.y + 50, 'Create new save', createSave);
        eraseButton = new FlxButton(createButton.x, createButton.y + 50, 'Erase this save', eraseSave);
        eraseButton.color = FlxColor.RED;
        eraseButton.label.color = FlxColor.WHITE;
        saveList = new FlxUIList();

        tab_group.add(loadButton);
        tab_group.add(createButton);
        tab_group.add(eraseButton);
        saveListBox.add(tab_group);
    }
    static inline function loadSave() {
        FlxG.switchState(new LoadDEFromProfiles());
    }
    static inline function createSave() {
        FlxG.sound.play(Paths.sound('menuConfirm'));
        new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(new ProfileSetupWizard());
				});
			});
    }
    static inline function eraseSave() {
        trace('test');
    }
    override function update(elapsed:Float) {
        if (itemDesc != null) {
            itemDesc.update(elapsed);
        }
        if (saveListBox != null) {
            saveListBox.update(elapsed);
        }
    }
}

/**setup wizard thingy*/
class ProfileSetupWizard extends FlxState {
    var bg:FlxSprite;
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
        "comment": "amogus"
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
        bg = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.scrollFactor.set();
        bg.color = 0xFFAACCFF;
        add(bg);
        FlxG.sound.playMusic(Paths.music('freakyMenu'));
        inDialogue = false;
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
        var dataToSave:String;
        var randomNumber:Int;
        function makeSetupUI() {
            var tab_group = new FlxUI(null, setupBox);
            tab_group.name = 'SHIT';

            var profileNameInputter:FlxUIInputText = new FlxUIInputText(10, 50, 150, basicBitch.profileName, 8);

            var bdayMonthInputter:FlxUIInputText = new FlxUIInputText(10, profileNameInputter.y + 30, 50, Std.string(basicBitch.playerBirthday[0]), 8);
            var bdayDateInputter:FlxUIInputText = new FlxUIInputText(bdayMonthInputter.x + 100, bdayMonthInputter.y, 50, Std.string(basicBitch.playerBirthday[1]), 8);

            var saveNameInputter:FlxUIInputText = new FlxUIInputText(10, bdayDateInputter.y + 30, 150, basicBitch.saveName, 8);

            var commentInputter:FlxUIInputText = new FlxUIInputText(10, saveNameInputter.y + 30, 150, basicBitch.comment, 8);

            var saveButton:FlxButton = new FlxButton(commentInputter.getGraphicMidpoint().x, commentInputter.y + 100, 'Done', function() {
                randomNumber = CustomRandom.int(0, someFunnyDefaultComments.length - 1);
                if (commentInputter.text.length >= 1) {
                    dataToSave = '{
                    "profileName": "' + profileNameInputter.text + '",
                    "playerBirthday":[ 
                        ' + bdayMonthInputter.text + ',
                        ' + bdayDateInputter.text + '
                    ],
                    "saveName": "' + saveNameInputter.text + '",
                    "comment": "' + commentInputter.text + '"
                }';
            } else {
                dataToSave = '{
                    "profileName": "' + profileNameInputter.text + '",
                    "playerBirthday":[ 
                        ' + bdayMonthInputter.text + ',
                        ' + bdayDateInputter.text + '
                    ],
                    "saveName": "' + saveNameInputter.text + '",
                    "comment": "' + someFunnyDefaultComments[randomNumber] + '"
                }';
            }
                trace(dataToSave);
                saveProfile(dataToSave);
            });

            tab_group.add(new FlxText(10, profileNameInputter.y - 18, 0, 'Profile name', 8));
            tab_group.add(new FlxText(10, bdayMonthInputter.y - 18, 0, 'Birthday', 8));
            tab_group.add(new FlxText(10, saveNameInputter.y - 18, 0, 'Save name', 8));
            tab_group.add(new FlxText(10, commentInputter.y - 18, 0, 'Comment', 8));
            tab_group.add(profileNameInputter);
            tab_group.add(bdayMonthInputter);
            tab_group.add(bdayDateInputter);
            tab_group.add(saveNameInputter);
            tab_group.add(commentInputter);
            tab_group.add(saveButton);
            setupBox.add(tab_group);
        }
        var houston:Bool = false;
        var newThing:FlxSave;
        function saveProfile(profile:String) {
            var hhhhhh = cast Json.parse(profile);
            if (FileSystem.exists('profiles/' + hhhhhh.profileName)) {
                trace('MUST ASK IF WE WILL OVERWRITE!');
                houston = true; //houston, we've got a problem
                dumb = cast Json.parse(Paths.snowdriftChatter('profileConflict'));
            } else {
                sys.io.File.write('profiles/' + hhhhhh.profileName + '.json');
                sys.io.File.saveContent('profiles/' + hhhhhh.profileName + '.json', profile);
                newThing = new FlxSave();
                newThing.bind(hhhhhh.saveName, 'fridayNightBrocken');
                trace(newThing);
                newThing.data.profileName = hhhhhh.profileName;
                newThing.data.playerBirthday = hhhhhh.playerBirthday;
                newThing.data.saveName = hhhhhh.saveName;
                newThing.data.comment = hhhhhh.comment;
            }
        }
}

class LoadDEFromProfiles extends MusicBeatState {
    public function new() {
        super();
    }

    override function create() {
        LoadingState.loadAndSwitchState(new editors.DialogueEditorState());
    }
}