package options.profileManagement;

import randomShit.util.DumbUtil;
import flixel.util.FlxSave;
import haxe.Exception;
import flixel.text.FlxText;
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
class ProfileSelectionState extends MusicBeatState {
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
    var action:String = '';
    var BG_COLOR:FlxColor;
    var you:String = TitleState.currentProfile.profileName;

    var bg:FlxSprite;
    var hint:HintMessageAsset;

    public function new(state:Int) {
        super();
        createSaveList();
        if (state == 0) {
            BG_COLOR = 0xFF007F00;
            action = 'edit';
        } else if (state == 1) {
            BG_COLOR = 0xFFFF0000;
            action = 'delete';
        }
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

    function getMissingSaves() {
        hint.setText("Checking your Windows save data directory...");
        var lis = SusFS.readDirectory(Sys.getEnv("APPDATA"));
        if (lis.length >= 1) {
            var pee:Int = 0;
            for (file in lis) {
                trace(file);
                var jesusSavesMyVagina:FlxSave = new FlxSave();
                jesusSavesMyVagina.bind(DumbUtil.snipName(file), 'fridayNightBrocken');
                if (Paths.fileExists('profiles/' + jesusSavesMyVagina.data.profileName + '.json', TEXT)) {
                    continue;
                } else {
                    ProfileUtil.saveNewProfile({
                        "profileName": jesusSavesMyVagina.data.profileName,
                        "playerBirthday": jesusSavesMyVagina.data.playerBirthday,
                        "comment": jesusSavesMyVagina.data.comment,
                        "profileIcon": jesusSavesMyVagina.data.profileIcon,
                        "saveName": jesusSavesMyVagina.data.saveName
                    }, jesusSavesMyVagina.data.profileName);
                }
                pee++;
                if (pee > lis.length) {
                    hint.setText("Restored $pee saves, resetting state...");
                    if (action == 'edit')
                    MusicBeatState.switchState(new ProfileSelectionState(0));
                    else
                    MusicBeatState.switchState(new ProfileSelectionState(1));
                }
            }
        }
    }
    var blockInput:Bool = false;
    override function create() {
        /*if (FlxG.sound.music == null) {
            FlxG.sound.playMusic(Paths.music('wiiPlay_Menu'), 0.7);
        } */
        bg = new FunkyBackground().setColor(BG_COLOR, false);
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

        hint = new HintMessageAsset('Select a profile to ' + action, 24, SusScreenShit.screenResolutionY <= 768);
        add(hint);
        add(hint.ADD_ME);
    }

    override function update(elapsed:Float) {
        if (!blockInput) {
            if (controls.UI_UP_P) {
                changeSelection(-1);
            }
            if (controls.UI_DOWN_P) {
                changeSelection(1);
            }
            if (controls.ACCEPT) {
                    if (action == 'edit') {
                        loadThisProfile(curSelected);
                    } else {
                        if (saveList[curSelected] != you) openSubState(new Prompt('Are you sure you want to delete ' + saveList[curSelected] + '? Their data will be all GONE if you do this!', 0, deleteSave, null, false, 'Delete', 'Cancel', 'warning'));
                            else doSelfWarn();
                    }
            }
            if (FlxG.keys.justPressed.H) {
                getMissingSaves();
            }
            if (controls.BACK) {
                LoadingState.loadAndSwitchState(new options.profileManagement.ProfileManagementState());
            }
        }
        super.update(elapsed);
    }
    var warnCount:Int = 0;
    function doSelfWarn() {
        blockInput = true;
        var warnTxtThing:String = '';
        if (warnCount <= 5) {
            warnTxtThing = "What are you doing, you can't delete your own save file!";
        } else if (warnCount <= 10 && warnCount >= 5) {
            warnTxtThing = "Dude. " + you + ", you can't delete your own save file.";
        } else if (warnCount >= 10) {
            warnTxtThing = "HEY. " + you.toUpperCase() + ". YOU CAN'T. DELETE. YOUR OWN. SAVE FILE.";
        }
        warnCount += 1;
        FlxG.sound.play(Paths.sound('errorSound'));
        var dsjfak:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x69000000);
        add(dsjfak);
        var jejes:FlxText = new FlxText(0, 0, 0, warnTxtThing, 24);
        jejes.setFormat("VCR OSD Mono", 24, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
        jejes.screenCenter();
        add(jejes);
        new FlxTimer().start(3, function(m:FlxTimer) {
            if (warnCount <= 15) {
                dsjfak.destroy();
                dsjfak = null;
                jejes.destroy();
                jejes = null;
                blockInput = false;
            } else {
                throw new Exception("Ok buddy that's it.\n" + you + ". Buddy.\nYou can't delete your own save file. If you want to do that, use another profile first.");
            }
        });
    }

    function loadThisProfile(profileIndex:Int) {
        LoadingState.loadAndSwitchState(new options.profileManagement.ProfileEditorState(PARSED_LIST[profileIndex]));
    }

    function deleteSave() {
        ProfileUtil.removeProfile(saveList[curSelected]);
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
                if (action == 'delete') iconArray[i].animation.curAnim.curFrame = 0;
            }
    
            iconArray[curSelected].alpha = 1;
            if (action == 'delete') iconArray[curSelected].animation.curAnim.curFrame = 1;
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
    }
}