package options.profileManagement;

import flixel.FlxG;
import randomShit.dumb.FunkyBackground;
import flixel.group.FlxGroup.FlxTypedGroup;
import ProfileThingy.ProfileShit;
import randomShit.util.ProfileUtil;
import randomShit.util.ProfileException;
import Prompt;
import randomShit.dumb.FunkyBackground;
import Alphabet;

using StringTools;

/**Profile management state. Coming soon:tm:
    @since March 2022 (Emo Engine 0.1.2)*/
class ProfileManagementState extends MusicBeatState {
    var optionList:Array<String> = ['Switch profile', 'Create new profile', 'Edit a profile', 'Edit your profile', 'Favourites manager', 'Delete a profile'];
    var options:FlxTypedGroup<Alphabet>;
    var removeIfAnon:String = 'Edit your profile';
    var removeIfNoProfiles:String = 'Edit a profile';
    var pList:Array<String> = ProfileUtil.getProfileList();
    public function new() {
        super();
        doOptionChecks();
    }

    function doOptionChecks() {
        if (pList.length >= 1) {
            asLongAsYouAreNamed();
        } else {
            optionList.remove(removeIfAnon);
            optionList.remove(removeIfNoProfiles);
            optionList.remove('Switch profile');
        }
    }
    var selectorLeft:Alphabet;
    var selectorRight:Alphabet;
    override function create() {
        add(new FunkyBackground().setColor(0xFF00007F, false));
        options = new FlxTypedGroup<Alphabet>();
        add(options);
        for (option in optionList) {
            var optionText:Alphabet = new Alphabet(0, 0, option, true, false);
			trace(optionText.text);
			optionText.screenCenter();
			optionText.y += (100 * (optionList.indexOf(option) - (optionList.length / 2))) + 50;
			options.add(optionText);
        }

        selectorLeft = new Alphabet(0, 0, '>', true, false);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true, false);
		add(selectorRight);

        changeSelection();

        super.create();
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
			FlxG.sound.play(Paths.sound('cancelMenu'));
			/* FlxG.sound.music.stop();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0); */ //dont need it

		FlxG.sound.music.fadeIn(4, 0, 0.7);
			FlxG.switchState(new OptionsStateExtra());
		}

        if (controls.ACCEPT) {
            funnyLoad();
        }
    }
    var curSelected:Int;
    function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = optionList.length - 1;
		if (curSelected >= optionList.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in options.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
    }

    function funnyLoad() {
        switch (optionList[curSelected]) {
            case 'Switch profile':
                openSubState(new Prompt('Are you sure you want to switch profiles? This will restart the game!', 1, restartGame, null, false, 'Continue', 'Cancel', 'warning'));
            case 'Create new profile':
                LoadingState.loadAndSwitchState(new ProfileSetupWizard());
            case 'Edit your profile':
                LoadingState.loadAndSwitchState(new ProfileEditorState(TitleState.currentProfile));
            case 'Edit a profile':
                LoadingState.loadAndSwitchState(new ProfileSelectionState(0));
            case 'Delete a profile':
                LoadingState.loadAndSwitchState(new ProfileSelectionState(1));
            case 'Favourites manager':
                LoadingState.loadAndSwitchState(new profile.ProfileFavouriteMenu());
        }
    }

    function asLongAsYouAreNamed() {
        if (TitleState.currentProfile != null) {
            switch (TitleState.currentProfile.profileName) {
                case 'debugBot' | 'Guest' | 'placeholderprofile':
                    // this is the same as being anonymous!!
                    doAnonRemove();
                default:
                    return;
            }
            if (pList.length >= 1 && pList[0] == 'no profiles') {
                optionList.remove(removeIfNoProfiles);
            }
        } else doAnonRemove();
    }

    function doAnonRemove() {
        optionList.remove('Switch Profile');
        optionList.remove(removeIfAnon);
        optionList.remove('Favourites manager');
    }

    function restartGame() {
        FlxG.save.bind('funkin', 'ninjamuffin99');
        FlxG.resetGame();
    }
}