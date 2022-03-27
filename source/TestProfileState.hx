package;

import randomShit.util.SussyUtilities;
import randomShit.dumb.InteractionThing.InteractionDialogues;
import randomShit.util.ProfileUtil;
import flixel.util.FlxColor;
import ProfileThingy; // for the profile shit.
import randomShit.util.HintMessageAsset;
import randomShit.dumb.FunkyBackground;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;
import flixel.ui.FlxButton; // for menu popup
import FlxUIDropDownMenuCustom;
import Alphabet;
import HealthIcon;
import AntivirusAvoidanceState; // JUST in case i add sus functions. lmao
import haxe.Json as SusJson;
import openfl.system.Capabilities as SusScreenShit;
#if sys
import sys.FileSystem as SusFS;
import sys.io.File as SusFile;
#else
import openfl.assets.Assets;
#end

using StringTools;

/**Gonna test another method of showing the profile menu.
    @since March 2022 (Emo Engine 0.1.2)*/
class TestProfileState extends FlxState {
    var saveList:Array<String> = []; // this'll be set when we call new
    var grpNames:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var iconArray:Array<HealthIcon> = [];
    var commentArray:Array<String> = [];
    var PARSED_LIST:Array<ProfileShit> = [];
    private var UpKeys:Array<FlxKey> = [FlxKey.UP, FlxKey.W];
    private var DownKeys:Array<FlxKey> = [FlxKey.DOWN, FlxKey.S];
    private var MenuKey:FlxKey = FlxKey.M;
    private var AcceptKey:FlxKey = FlxKey.ENTER;

    var bg:FlxSprite;
    var hint:HintMessageAsset;

    public function new() {
        super();
        createSaveList();
        if (!SussyUtilities.FUNCTIONS_CEASED) SussyUtilities.setupTheVars();
    }

    function createSaveList() {
        if (!SusFS.exists('profiles') || SusFS.readDirectory('profiles').length == 0) {
            trace('NO PROFILES!!');
            saveList.push('No profiles');
            //iconArray.push(new HealthIcon('bf'));
            commentArray.push('Press the M key to open the menu and make a profile!');
        } else {
            var sl = SusFS.readDirectory('profiles');
            for (save in sl) {
                var sf:ProfileShit = SusJson.parse(SusFile.getContent('profiles/' + save));
                saveList.push(sf.profileName);
                PARSED_LIST.push(sf);
                commentArray.push(sf.comment);
            }
        }
    }

    override function create() {
        if (FlxG.sound.music == null) {
            FlxG.sound.playMusic(Paths.music('wiiPlay_Menu'), 0.7);
        }
        bg = new FunkyBackground().setColor(0xFF0000FF, false);
        add(bg);

        grpNames = new FlxTypedGroup<Alphabet>();
        add(grpNames);
        if (saveList.length >= 1 && saveList[0] != 'No profiles') {
            for (save in 0...saveList.length) {
                var sEntry = new Alphabet(0, (70 * save) + 30, saveList[save], true, false);
                sEntry.isMenuItem = true;
                sEntry.targetY = save;

                grpNames.add(sEntry);

                var icon:HealthIcon = new HealthIcon(PARSED_LIST[save].profileIcon);
                icon.sprTracker = sEntry;

                iconArray.push(icon);
                add(icon);
            }
        } else {
            for (i in 0...1) {
                var sEntry = new Alphabet(0, (70 * i) + 30, saveList[i], true, false);
                sEntry.targetY = i;

                grpNames.add(sEntry);

                var icon:HealthIcon = new HealthIcon('bf');
                icon.sprTracker = sEntry;
                iconArray.push(icon);
                add(icon);
            }
        }

        hint = new HintMessageAsset(commentArray[0], 24, SusScreenShit.screenResolutionY <= 768);
        add(hint);
        add(hint.ADD_ME);
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.anyJustPressed(UpKeys)) {
            changeSelection(-1);
        }
        if (FlxG.keys.anyJustPressed(DownKeys)) {
            changeSelection(1);
        }
        if (FlxG.keys.checkStatus(MenuKey, flixel.input.FlxInput.FlxInputState.JUST_PRESSED)) {
            openSubState(new TestProfileSubstate());
        }

        if (FlxG.keys.checkStatus(AcceptKey, flixel.input.FlxInput.FlxInputState.JUST_PRESSED)) {
            if (saveList.length >= 1 && saveList[0] != 'No profiles') {
                loadSelectedProfile();
            } else {
                FlxG.switchState(new MusicBeatLauncher(new NoProfileState())); // MusicBeatLauncher is a class that loads musicbeatstates from flxstates
            }
        }
        
        #if debug
        if (FlxG.keys.justPressed.SEVEN) {
            FlxG.switchState(new MusicBeatLauncher(new randomShit.dumb.SoundtrackMenu()));
        }
        #end
        super.update(elapsed);
    }

    function loadSelectedProfile() {
        TitleState.currentProfile = PARSED_LIST[curSelected];
        ProfileUtil.setUtilData(PARSED_LIST[curSelected]);
        FlxG.sound.play(Paths.sound('confirmMenu'));
        new FlxTimer().start(0.7, function(j:FlxTimer) {
            trace('the j');
            FlxG.cameras.fade(0xFF000000, 2, false, function() {
                FlxG.switchState(new TitleState());
            });
        });
    }

    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected += change;
        if (curSelected < 0) {
            curSelected = grpNames.length - 1;
        }
        if (curSelected >= grpNames.length) {
            curSelected = 0;
        }

        for (i in 0...iconArray.length)
            {
                iconArray[i].alpha = 0.6;
            }
    
            iconArray[curSelected].alpha = 1;
            var bullShit:Int = 0;
            for (item in grpNames.members)
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
            hint.ADD_ME.text = commentArray[curSelected];
            hint.ADD_ME.fieldWidth = 0;
    }
}

/**Menu substate for this test. In debug builds, it'll contain the same skip button as the currently used launcher state
    @since March 2022 (Emo Engine 0.1.2)*/
class TestProfileSubstate extends flixel.FlxSubState {
    var guestProfile:ProfileShit = {
        "profileName": "Guest",
        "playerBirthday": randomShit.util.DevinsDateStuff.getTodaysDate(),
        "saveName": "guestProfile",
        "comment": "You're a little rascal.",
        "profileIcon": "bf"
    };
    var useGuestButton:FlxButton;
    var newProfileButton:FlxButton;
    var delProfileButton:FlxButton;
    
    public function new() {
        super();
    }

    override function create() {
        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x69000000);
        add(bg);
        
        useGuestButton = new FlxButton(0, 0, 'Guest', startAsGuest);
        useGuestButton.screenCenter();
        add(useGuestButton);

        newProfileButton = new FlxButton(0, 0, 'New Profile', launchSetupState);
        newProfileButton.setPosition(300);
        newProfileButton.screenCenter(Y);
        add(newProfileButton);

        delProfileButton = new FlxButton(0, 0, 'Delete Profile', launchDelState);
        delProfileButton.setPosition(600);
        delProfileButton.screenCenter(Y);
        add(delProfileButton);

        #if debug
        var dbgTestButton:FlxButton = new FlxButton(150, 150, 'DEBUG PROFILE', useDbgProfile);
        dbgTestButton.color = 0xFF0000FF;
        dbgTestButton.label.color = 0xFFFFFFFF;
        add(dbgTestButton);
        #end
    }

    #if debug
    function useDbgProfile() {
        var dbgProfile:ProfileShit = {
            "profileName": "debugBot",
            "playerBirthday": [
                11,
                18
            ],
            "saveName": "debugSave",
            "comment": "How are you seeing this on the save list?!",
            "profileIcon": "devin"
        };
        TitleState.currentProfile = dbgProfile;
        FlxG.sound.play(Paths.sound('menuConfirm'));
        FlxG.sound.music.stop();
        FlxG.sound.music = null;
        new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(new TitleState());
				});
			});
    }
    #end

    function startAsGuest() {
        TitleState.currentProfile = guestProfile;
        FlxG.sound.play(Paths.sound('menuConfirm'));
        FlxG.sound.music.stop();
        FlxG.sound.music = null;
        new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(new TitleState());
				});
			});
    }

    function launchSetupState() {
        FlxG.sound.play(Paths.sound('confirmMenu'));
        FlxG.sound.music.stop();
        FlxG.sound.music = null;
        new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(new ProfileSetupWizard());
				});
			});
    }

    function launchDelState() {
        FlxG.sound.play(Paths.sound('confirmMenu'));
        FlxG.sound.music.stop();
        FlxG.sound.music = null;
        new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(new DeleteAProfile());
				});
			});
    }
}

/**Just so I can delete in the same HX file idk
    @since March 2022 (Emo Engine 0.1.2)*/
class DeleteAProfile extends FlxState {
    var bg:FunkyBackground;
    var delButton:FlxButton;
    var cancelButton:FlxButton;
    var saveList:Array<String> = [];
    var jsonlist:Array<ProfileShit> = [];
    var dropdown:FlxUIDropDownMenuCustom;

    public function new() {
        super();
        grabSaves();
    }

    function grabSaves() {
        if (!SusFS.exists('profiles') || SusFS.readDirectory('profiles').length == 0) {
            trace('NO PROFILES!!');
            saveList.push('No profiles');
            //iconArray.push(new HealthIcon('bf'));
            //commentArray.push('Press the M key to open the menu and make a profile!');
        } else {
            var sl = SusFS.readDirectory('profiles');
            for (save in sl) {
                var sf:ProfileShit = SusJson.parse(SusFile.getContent('profiles/' + save));
                saveList.push(sf.profileName);
                jsonlist.push(sf);
                //commentArray.push(sf.comment);
            }
        }
    }

    override function create() {
        bg = new FunkyBackground().setColor(0xFF7F0000, false);
        add(bg);

        delButton = new FlxButton(150, 500, 'Delete', function() {
            FlxG.sound.play(Paths.sound('mario-scream'), 1, false, null, true, function() {
                throw new haxe.Exception('penis');
            });
        });
        add(delButton);
    }
}