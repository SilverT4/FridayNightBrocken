package profile;

import options.profileManagement.ProfileManagementState;
import flixel.group.FlxGroup.FlxTypedGroup;
import Alphabet;
import randomShit.util.DumbUtil;
import randomShit.dumb.FunkyBackground;
import randomShit.util.HintMessageAsset;
import profile.FavUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

using StringTools;

/**Management class. This will be accessible from the profile management menu.
    @since March 2022 (Emo Engine 0.1.2)*/
class ProfileFavouriteMenu extends MusicBeatState {
    var yourFavourites:ProfileFavourite;
    var tre:FunkyBackground;
    var optionList:Array<String> = ['Manage Songs', 'Manage Characters', 'Exit'];
    var grpOpt:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var playerIcon:HealthIcon;
    var selectorRight:Alphabet;

    public function new() {
        super();
        if (TitleState.currentProfile != null) {
            if (FlxG.save.data.profileFavourites != null) FavUtil.getFavs();
            else FavUtil.initFavs();
        }
    }

    override function create() {
        playerIcon = new HealthIcon(TitleState.currentProfile.profileIcon);
        var henis:Alphabet = new Alphabet(0, 2, TitleState.currentProfile.profileName, false, false);
        playerIcon.sprTracker = henis;
        tre = new FunkyBackground().setColor(CoolUtil.dominantColor(playerIcon), false);
        add(tre);
        add(henis);
        add(playerIcon);
        grpOpt = new FlxTypedGroup<Alphabet>();
        add(grpOpt);
        for (opt in 0...optionList.length) {
            var optionText:Alphabet = new Alphabet(0, 0, optionList[opt], true, false);
			trace(optionText.text);
			optionText.screenCenter();
			optionText.y += (100 * (opt - (optionList.length / 2))) + 50;
			grpOpt.add(optionText);
        }

        selectorRight = new Alphabet(0, 0, '>', true, false);

        changeSelection();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.UI_UP_P) {
            changeSelection(-1);
        }
        if (controls.UI_DOWN_P) {
            changeSelection(1);
        }
        if (controls.ACCEPT) {
            openSelectedManager();
        }
        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            LoadingState.loadAndSwitchState(new options.profileManagement.ProfileManagementState());
        }
    }

    function openSelectedManager() {
        switch (optionList[curSelected]) {
            case 'Manage Songs':
                LoadingState.loadAndSwitchState(new profile.FavSongState());
            case 'Manage Characters':
                LoadingState.loadAndSwitchState(new profile.FavCharState());
            case 'Exit':
                LoadingState.loadAndSwitchState(new options.profileManagement.ProfileManagementState());
        }
    }

    function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = optionList.length - 1;
		if (curSelected >= optionList.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOpt.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}