package profile;

import profile.FavUtil;
import flixel.FlxG;
import CheckboxThingie;
import Alphabet;
import flixel.util.FlxColor;
import randomShit.dumb.FunkyBackground;
import randomShit.util.DumbUtil;
import MusicBeatState;
import flixel.FlxSprite;
import HealthIcon;
import flixel.text.FlxText;
import randomShit.util.HintMessageAsset;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

/**This state allows you to make changes to your favourite songs.
    @since March 2022 (Emo Engine 0.1.2)*/
class FavSongState extends MusicBeatState {
    var bg:FunkyBackground;
    var yourSongs:Array<String> = [];
    var yourFavData:ProfileFavourite;
    var songList:FlxTypedGroup<Alphabet>;
    var songNames:Array<String> = [];
    var songIcons:Array<HealthIcon> = [];
    var songIcons_String:Array<String> = [];
    var checkArray:Array<CheckboxThingie> = [];

    public function new() {
        super();
        WeekData.reloadWeekFiles(false);
        yourFavData = FavUtil.getFavs();
        yourSongs = yourFavData.favouriteSongs;
        songNames = DumbUtil.getSongList();
        songIcons_String = DumbUtil.getSongIcons();
    }

    override function create() {
        bg = new FunkyBackground();
        bg.setColor(0xFF696969, false);
        add(bg);
        songList = new FlxTypedGroup<Alphabet>();
        add(songList);
        for (song in 0...songNames.length) {
            var checker:CheckboxThingie = new CheckboxThingie(0, (70 * song), yourSongs.contains(songNames[song]));
            add(checker);
            checkArray.push(checker);
            var sEntry = new Alphabet(0, (70 * song) + 30, songNames[song], true, false);
                sEntry.isMenuItem = true;
                sEntry.targetY = song;
                checker.sprTracker = sEntry;

                songList.add(sEntry);

                var icon:HealthIcon = new HealthIcon(songIcons_String[song]);
                icon.sprTracker = sEntry;

                songIcons.push(icon);
                add(icon);
        }
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
            setFavSong();
        }
        if (controls.RESET) {
            openSubState(new Prompt("Are you sure you want to reset your favourite songs? This is an irreversible action!", 1, resetFavSongs, null, false, 'Reset', 'Cancel', 'xpExclam'));
        }
        if (controls.BACK) {
            openSubState(new Prompt("Would you like to save your changes?", 0, saveData, exitWithoutSaving, false, 'Yes', 'No', 'information'));
        }
    }

    function setFavSong() {
        if (yourSongs.contains(songNames[curSelected])) {
            yourSongs.remove(songNames[curSelected]);
            checkArray[curSelected].daValue = yourSongs.contains(songNames[curSelected]);
        } else {
            yourSongs.push(songNames[curSelected]);
            checkArray[curSelected].daValue = yourSongs.contains(songNames[curSelected]);
        }
    }

    function resetFavSongs() {
        yourSongs = [];
        yourFavData.favouriteSongs = [];
        FavUtil.setFavs(yourFavData.favouriteSongs, yourFavData.favouriteChars);
        MusicBeatState.resetState();
    }

    function exitWithoutSaving() {
        LoadingState.loadAndSwitchState(new ProfileFavouriteMenu());
    }

    function saveData() {
        FavUtil.setFavs(yourSongs, yourFavData.favouriteChars);
        LoadingState.loadAndSwitchState(new ProfileFavouriteMenu());
    }
    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected += change;
        if (curSelected < 0) {
            curSelected = songNames.length - 1;
        }
        if (curSelected >= songNames.length) {
            curSelected = 0;
        }

        for (i in 0...songIcons.length)
            {
                songIcons[i].alpha = 0.6;
            }
            for (i in 0...checkArray.length) {
                checkArray[i].alpha = 0.6;
            }
    
            songIcons[curSelected].alpha = 1;
            checkArray[curSelected].alpha = 1;
            var bullShit:Int = 0;
            for (item in songList.members)
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

	var curSelected:Int = 0;
}