package options.profileManagement;

import randomShit.util.CustomRandom;
import flixel.FlxG;
import flixel.FlxSprite;
import randomShit.util.ProfileUtil;
import randomShit.dumb.FunkyBackground;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import randomShit.util.HintMessageAsset;
import ProfileThingy.ProfileShit;
import ProfileThingy.DebugProfileSubstate.girlYes;

using StringTools;

/**Editor state for profiles. Allows you to edit your own profile or another.
    @since March 2022 (Emo Engine 0.1.2)*/
class ProfileEditorState extends MusicBeatState {
    var theProfile:ProfileShit;
    var setupBox:FlxUITabMenu;
    
    public function new(EditProfile:ProfileShit) {
        super();
        theProfile = EditProfile;
    }

    override function create() {
        add(new FunkyBackground().setColor(0xFFAACCFF, false));
        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
            #if debug
            FlxG.mouse.useSystemCursor = true; // for the funny idk
            #end
        }
        makeTheBox();
    }
    function makeTheBox() {
        var tabs = [{name: 'SHIT', label: 'Setup'}];
            setupBox = new FlxUITabMenu(null, tabs, true);
            setupBox.resize(250, 300);
            setupBox.screenCenter();
            add(setupBox);
            makeSetupUI();
    }
    var dataToSave:ProfileShit;
    var randomComment:String = '';
    function makeSetupUI() {
        var tab_group = new FlxUI(null, setupBox);
        tab_group.name = 'SHIT';

        var profileNameInputter:FlxUIInputText = new FlxUIInputText(10, 50, 150, theProfile.profileName, 8);

        var bdayMonthInputter:FlxUIInputText = new FlxUIInputText(10, profileNameInputter.y + 30, 50, Std.string(theProfile.playerBirthday[0]), 8);
        var bdayDateInputter:FlxUIInputText = new FlxUIInputText(bdayMonthInputter.x + 100, bdayMonthInputter.y, 50, Std.string(theProfile.playerBirthday[1]), 8);

        var saveNameInputter:FlxUIInputText = new FlxUIInputText(10, bdayDateInputter.y + 30, 150, theProfile.saveName, 8);

        var commentInputter:FlxUIInputText = new FlxUIInputText(10, saveNameInputter.y + 30, 150, theProfile.comment, 8);
        var profileIconInputter:FlxUIInputText = new FlxUIInputText(10, commentInputter.y + 30, 150, theProfile.profileIcon, 8);
        var saveButton:FlxButton = new FlxButton(commentInputter.getGraphicMidpoint().x, commentInputter.y + 100, 'Update', function() {
            randomComment = getRandomComment();
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
                "comment": randomComment,
                "profileIcon": profileIconInputter.text
            };
        }
            trace(dataToSave);
            updateProfile(dataToSave);
        });

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
    function getRandomComment() {
        var randoComments = [
        'Insert funny comment here',
        'I like the snow',
        'Dumb boyfriend steal your comment? Buy this sexy cum product to cure!',
        'All your notes are belong to me',
        'Never gonna give you up...',
        'You have been bread loafed. Share this within the next 69 seconds to bread loaf someone else'];
        for (comment in girlYes) {
            randoComments.push(comment);
        }
        return randoComments[CustomRandom.int(0, randoComments.length)];
    }

    function updateProfile(PORN:ProfileShit) {
        ProfileUtil.updateExistingSave(PORN.profileName, PORN);
        FlxG.sound.play(Paths.sound('confirmMenu'), 1, false, null, true, function() {
            LoadingState.loadAndSwitchState(new options.profileManagement.ProfileManagementState());
        });
    }

	var randomNumber:Int;
}