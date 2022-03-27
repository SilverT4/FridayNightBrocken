package randomShit.dumb;

import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import AttachedSprite; // THESE MAY MOVE TO A SUBSTATE SOON!
import randomShit.util.ColorUtil;
import flixel.FlxG;
import randomShit.util.HintMessageAsset;
import randomShit.dumb.FunkyBackground;
import flixel.system.FlxSound;
import Alphabet;
import HealthIcon;
import flixel.FlxSprite;
import randomShit.util.DumbUtil;
import randomShit.util.SoundtrackUtil;
import Song; // FOR SWAGSONG!!
import CoolUtil;
using StringTools;

/**OST Data.
    @param songName The name of the song.
    @param defaultOpponent The default opponent (aka Edd, Dave, etc.) of your song
    @param defaultBf The default boyfriend (aka BF, Bambi, etc.) of your song
    @param songColor The background colour you want for your song. By default, if this is [0,0,0] or you don't add this while typing a json manually, the game will use the dominant colour of your *opponent* icon.
    @param hasVoices Whether the song has a vocal track. If it *does*, set this to true.
    @since March 2022 (Emo Engine 0.1.2)*/
typedef OSTData = {
    /**The song's name.*/
    var songName:String;
    /**The default opponent of your song.*/
    var defaultOpponent:String;
    /**The default bf of your song.*/
    var defaultBf:String;
    /**The background colour of your song in RGB format.*/
    var songColor:Array<Int>;
    /**Whether the song has a vocal track.*/
    var hasVoices:Bool;
}
/**A menu for a list of your soundtracks. Also includes the base game songs.
@since March 2022 (Emo Engine 0.1.2)*/
class SoundtrackMenu extends MusicBeatState {
    var songList_Full:Array<OSTData> = [];
    var iconArray:Array<HealthIcon> = [];
    var grpSongs:FlxTypedGroup<Alphabet>;
    var curSelected:Int = 0;
    var bgColorList:Array<FlxColor> = [];
    var playerIcons_Dad:Array<String> = [];
    var playerIcons_Bf:Array<String> = [];
    var songBarBg:FlxSprite;
    var songBar:FlxBar;
    var bg:FunkyBackground;
    var dadIcon:HealthIcon;
    var bfIcon:HealthIcon;
    var eduardoIcon:HealthIcon;
    var instrumentals:Array<FlxSound> = []; // for the purpose of functions
    var vocalTracks:Array<FlxSound> = [];
    var playingSong:Bool = false;
    var instOnly:Bool = false;
    var hasVoices:Bool = false;
    var songHasVoices:Array<Bool> = [false];
    var songPos:Float = 0;
    var timeHint:HintMessageAsset;
    var curSong:String = '';
    public function new() {
        /*baseSongInfos = [
            ["Tutorial", "gf", "bf", getIconColorFromFile('gf')],
            ["Bopeebo", "dad", "bf", getIconColorFromFile('dad')],
            ["Fresh", "dad", "bf", getIconColorFromFile('dad')],
            ["Dad-Battle", "dad", "bf", getIconColorFromFile('dad')],
            ["Spookeez", "spooky", "bf", getIconColorFromFile('spooky')],
            ["South", "spooky", "bf", getIconColorFromFile('spooky')],
            ["Monster", "monster", "bf", getIconColorFromFile('monster')],
            ["Pico", "pico", "bf", getIconColorFromFile('pico')],
            ["Philly-Nice", "pico", "bf", getIconColorFromFile('pico')],
            ["Blammed", "pico", "bf", getIconColorFromFile('pico')],
            ["Satin-Panties", "mom", "bf", getIconColorFromFile('mom')],
            ["High", "mom", "bf", getIconColorFromFile('mom')],
            ["Milf", "mom", "bf", getIconColorFromFile('mom')],
            ["Eggnog", "parents-christmas", "bf", getIconColorFromFile('parents-christmas')],
            ["Cocoa", "parents-christmas", "bf", getIconColorFromFile('parents-christmas')],
            ["Winter-Horrorland", "monster", "bf", getIconColorFromFile('monster')],
            ["Senpai", "senpai-pixel", "bf-pixel", getIconColorFromFile('senpai-pixel')],
            ["Roses", "senpai-pixel", "bf-pixel", getIconColorFromFile('senpai-pixel')],
            ["Thorns", "spirit-pixel", "bf-pixel", getIconColorFromFile('spirit-pixel')]
        ];
        modSongInfos = getModOsts();
        doFunnyConverts(baseSongInfos);
        doFunnyConverts(modSongInfos); */
        /*for (i in 0...18) {
            songHasVoices.push(true);
        } */
        songList_Full = SoundtrackUtil.getSoundtrackList();
        for (song in songList_Full) {
            #if debug
            FlxG.log.notice((songList_Full.indexOf(song) + 1) + ' of ' + songList_Full.length + ': Setting hasVoices of ' + song.songName + ' to ' + song.hasVoices);
            #end
            songHasVoices.push(song.hasVoices);
        }
        super();
    }
    /*function getIconColorFromFile(charName:String) {
        var emoIcon:HealthIcon = new HealthIcon(charName);
        var colToReturn:Int = CoolUtil.dominantColor(emoIcon);
        emoIcon.destroy(); // TO NOT CAUSE *TOO* MUCH LAG I HOPE
        emoIcon = null;
        var ej:FlxColor = colToReturn;
        var penis = ej.getColorInfo();
        //splitToRgb(penis);
        return splitToRgb(penis);
    }

    function splitToRgb(ColorInfo:String) {
        var eheh = ColorInfo.split('\n');
        var meme = eheh[1].split(': ');
        trace(meme);
        return [Std.parseInt(meme[2].replace(' Green', '')), Std.parseInt(meme[3].replace(' Blue', '')), Std.parseInt(meme[4])];
    }*/

    override function create() {
        bg = new FunkyBackground();
        bg.setColor(DumbUtil.getBgRgbColor(songList_Full[0].songColor), false);
        add(bg);
        grpSongs = new FlxTypedGroup<Alphabet>();
        add(grpSongs);
        for (song in 0...songList_Full.length) {
            var jej:Alphabet = new Alphabet(0, (70 * song), songList_Full[song].songName, true, false);
            jej.isMenuItem = true;
            jej.targetY = song;
            //add(jej); **DUMBASS**
            grpSongs.add(jej);
            trace('Adding song ' + song + ' of ' + songList_Full.length + ': ' + songList_Full[song].songName);
            FlxG.log.notice('Adding song ' + song + ' of ' + songList_Full.length + ': ' + songList_Full[song].songName);

            var icon:HealthIcon = new HealthIcon(songList_Full[song].defaultOpponent);
            icon.sprTracker = jej;
            add(icon);
            iconArray.push(icon);

            var meena:FlxColor = DumbUtil.getBgRgbColor(songList_Full[song].songColor);
            bgColorList.push(meena);

            var player2_Icon:String = DumbUtil.parseChars([songList_Full[song].defaultOpponent])[0].healthicon;
            var player1_Icon:String = DumbUtil.parseChars([songList_Full[song].defaultBf])[0].healthicon;

            playerIcons_Dad.push(player2_Icon);
            playerIcons_Bf.push(player1_Icon);
            var instrumentalTrack:FlxSound = new FlxSound();
            instrumentalTrack.loadEmbedded(Paths.inst(Paths.formatToSongPath(songList_Full[song].songName)));
            instrumentals.push(instrumentalTrack);
            var vocalTrack:FlxSound = new FlxSound();
            trace(Paths.inst(songList_Full[song].songName.toLowerCase()));
            if (songHasVoices[song]) vocalTrack.loadEmbedded(Paths.voices(Paths.formatToSongPath(songList_Full[song].songName))) else vocalTrack.loadEmbedded(Paths.sound("introGo"));
            vocalTracks.push(vocalTrack);
        }
        eduardoIcon = new HealthIcon("eduardo");
        songBarBg = new FlxSprite(0, 50).loadGraphic(Paths.image("healthBar"));
        songBarBg.screenCenter(X);
        songBarBg.scrollFactor.set();
        add(songBarBg);
        songBarBg.kill();
        songBar = new FlxBar(songBarBg.x + 4, songBarBg.y + 4, RIGHT_TO_LEFT, Std.int(songBarBg.width - 8), Std.int(songBarBg.height - 8), this, "songPos", 0, 1);
        songBar.scrollFactor.set();
        songBar.createFilledBar(0xFF696969, 0xFFA6D388);
        add(songBar);
        songBar.kill();
        bfIcon = new HealthIcon(playerIcons_Bf[0]);
        bfIcon.y = songBar.y - (bfIcon.height / 2);
        add(bfIcon);
        bfIcon.kill();

        dadIcon = new HealthIcon(playerIcons_Dad[0]);
        dadIcon.y = songBar.y - (dadIcon.height / 2);
        add(dadIcon);
        eduardoIcon.y = dadIcon.y;
        add(eduardoIcon);
        eduardoIcon.kill();
        dadIcon.kill();

        timeHint = new HintMessageAsset("No song selected", 24, ClientPrefs.smallScreenFix);
        add(timeHint);
        add(timeHint.ADD_ME);
    }

    function playSong(SongData:OSTData) {
        grpSongs.forEach(function (alp:Alphabet) {
            if (alp.text != SongData.songName) {
                alp.kill();
                iconArray[grpSongs.members.indexOf(alp)].kill();
            }
        });
        songBarBg.revive();
        songBar.revive();
        dadIcon.revive();
        bfIcon.revive();
        reloadIcons();
        playingSong = true;
        FlxG.sound.music.fadeOut(0.7, 0, { function(h:FlxTween) {
            instrumentals[curSelected].play(false, 0, 0);
            instrumentals[curSelected].onComplete = doStopThings;
            vocalTracks[curSelected].play(false, 0, 0);
            FlxG.sound.music.pause();
        }});
    }

    function reloadIcons() {
        dadIcon.changeIcon(playerIcons_Dad[curSelected]);
        bfIcon.changeIcon(playerIcons_Bf[curSelected]);
        songBar.createFilledBar(DumbUtil.getBarColor(songList_Full[curSelected].defaultOpponent), DumbUtil.getBarColor(songList_Full[curSelected].defaultBf));
    }

    function doStopThings() {
        curSong = songList_Full[curSelected].songName;
        instrumentals[curSelected].stop();
        vocalTracks[curSelected].stop();
        FlxG.sound.music.fadeIn(0.7, 0, 0.7, { function(j:FlxTween) {
            trace('the j');
            FlxG.sound.music.resume();
        }});
        grpSongs.forEach(function(alp:Alphabet) {
            alp.revive();
            iconArray[grpSongs.members.indexOf(alp)].revive();
        });
        songBarBg.kill();
        songBar.kill();
        dadIcon.kill();
        bfIcon.kill();
        playingSong = false;
    }
    /**This just switches icon to eduardo and back. lmao*/
    function doIconEgg() {
        if (bfIcon.getCharacter() == 'eduardo') {
            bfIcon.changeIcon(playerIcons_Bf[curSelected]);
            songBar.createFilledBar(DumbUtil.getBarColor(songList_Full[curSelected].defaultOpponent), DumbUtil.getBarColor(songList_Full[curSelected].defaultBf));
        } else {
            bfIcon.changeIcon('eduardo');
            songBar.createFilledBar(DumbUtil.getBarColor(songList_Full[curSelected].defaultOpponent), DumbUtil.getBarColor("eduardo"));
        }
    }
    function seekInSong(seek:Int) {
        instrumentals[curSelected].time += seek;
        if (!instOnly || hasVoices) vocalTracks[curSelected].time += seek;
    }

    function doIconStuff() {
        if (songBar.percent >= 80) {
            if (dadIcon.sprTracker == null) dadIcon.animation.curAnim.curFrame = 1;
            if (eduardoIcon.alive) eduardoIcon.animation.curAnim.curFrame = 1;
        } else {
            if (dadIcon.sprTracker == null) dadIcon.animation.curAnim.curFrame = 0;
            if (eduardoIcon.alive) eduardoIcon.animation.curAnim.curFrame = 0;
        }
        if (songBar.percent <= 20) {
            bfIcon.animation.curAnim.curFrame = 1;
            if (dadIcon.sprTracker == bfIcon) dadIcon.animation.curAnim.curFrame = 1;
        } else {
            bfIcon.animation.curAnim.curFrame = 0;
            if (dadIcon.sprTracker == bfIcon) dadIcon.animation.curAnim.curFrame = 1;
        }
    }

    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected += change;
        if (curSelected < 0) {
            curSelected = songList_Full.length - 1;
        }
        if (curSelected >= songList_Full.length) {
            curSelected = 0;
        }

            var bullShit:Int = 0;
            for (item in grpSongs.members)
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
    override function update(elapsed:Float) {
        if (!playingSong) {
            if (controls.UI_UP_P) {
                changeSelection(-1);
            }
            if (controls.UI_DOWN_P) {
                changeSelection(1);
            }
            if (controls.ACCEPT) {
                playSong(songList_Full[curSelected]);
            }
            if (controls.BACK) {
                MusicBeatState.switchState(new options.OptionsStateExtra());
            }
        }

        if (playingSong) {
            songPos = 1 - (instrumentals[curSelected].time / instrumentals[curSelected].length);
            if (controls.UI_LEFT_P) {
                seekInSong(-5000);
            }
            if (controls.UI_RIGHT_P) {
                seekInSong(5000);
            }
            if (controls.BACK) {
                doStopThings();
            }
            if (FlxG.keys.justPressed.NINE) {
                doIconEgg();
            }

            bfIcon.x = songBar.x + (songBar.width * (FlxMath.remapToRange(songBar.percent, 0, 100, 100, 0) * 0.01) - 26);
		    if (dadIcon.sprTracker == null) dadIcon.x = songBar.x + (songBar.width * (FlxMath.remapToRange(songBar.percent, 0, 100, 100, 0) * 0.01)) - (dadIcon.width - 26);
            updateTimeHint();
            if (curSong.toLowerCase() == 'challeng-edd') {
                if (FlxStringUtil.formatTime(instrumentals[curSelected].time / 1000) == "1:15") {
                    eduardoIcon.revive();
                    dadIcon.sprTracker = bfIcon;
                    dadIcon.setGraphicSize(Std.int(dadIcon.width * 0.7));
                    dadIcon.y = bfIcon.y - 25;
                    dadIcon.flipX = true;
                }
            }
        }

        super.update(elapsed);
    }

    function updateTimeHint() {
        var curTimeFormat = FlxStringUtil.formatTime(instrumentals[curSelected].time / 1000);
        var lengthFormat = FlxStringUtil.formatTime(instrumentals[curSelected].length / 1000);
        timeHint.setText("Currently playing: " + songList_Full[curSelected].songName + " | " + curTimeFormat + " / " + lengthFormat);
    }
}