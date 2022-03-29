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
    /**Optionally set a different display name while playing the song.*/
    @:optional var displayName:String;
    /**The default opponent of your song.*/
    var defaultOpponent:String;
    /**What icon should the song show for the opponent while it's playing?*/
    var dadIcon:String;
    /**The default bf of your song.*/
    var defaultBf:String;
    /**What icon should the song show for bf while it's playing?*/
    var bfIcon:String;
    /**The background colour of your song in RGB format, in a neat little thing. Set to null if you use the Int array in your json.*/
    @:optional var songColorInfo:SongColorInfo;
    /**Song colour in RGB. Leave this null if you use the songColorInfo*/
    @:optional var songColor:Array<Int>;
    /**Whether the song has a vocal track.*/
    var hasVoices:Bool;
    /**Change the icons at certain points in the song. Leave this null if you want to keep the icons as is throughout.*/
    @:optional var iconChanges:Array<IconChange>;
}

typedef IconChange = {
    var time_ms:Int;
    var changeTarget:String; // DAD OR BF
    var newIcon:String;
}

typedef SongColorInfo = {
    /**The Red value of your colour.*/
    var red:Int;
    /**The Green value of your colour.*/
    var green:Int;
    /**The blue value of your colour.*/
    var blue:Int;
}
/**A menu for a list of your soundtracks. Also includes the base game songs.

@see SoundtrackUtil, located in `randomShit.util` (Provides utilities for this class)
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
    var enteringMusic:FlxSound;
    var opponentColors:Map<String, FlxColor> = new Map();
    var bfColors:Map<String, FlxColor> = new Map();
    var displayNames:Map<String, String> = new Map();
    var msTimes:Array<Float> = [];
    var chTargets:Array<String> = [];
    var newIcons:Array<String> = [];
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
        enteringMusic = FlxG.sound.music;
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
    } */

    function splitToRgb(ColorInfo:String) {
        var eheh = ColorInfo.split('\n');
        var meme = eheh[1].split(': ');
        trace(meme);
        return [Std.parseInt(meme[2].replace(' Green', '')), Std.parseInt(meme[3].replace(' Blue', '')), Std.parseInt(meme[4])];
    }

    override function create() {
        bg = new FunkyBackground();
        bg.setColor(DumbUtil.getBgRgbColor(songList_Full[0].songColor), false);
        add(bg);
        grpSongs = new FlxTypedGroup<Alphabet>();
        add(grpSongs);
        for (song in 0...songList_Full.length) {
            var textToDisplay:String = '';
            if (songList_Full[song].displayName != null) {
                textToDisplay = songList_Full[song].displayName;
            } else {
                textToDisplay = songList_Full[song].songName;
            }
            var jej:Alphabet = new Alphabet(0, (70 * song), textToDisplay, true, false);
            jej.isMenuItem = true;
            jej.targetY = song;
            //add(jej); **DUMBASS**
            grpSongs.add(jej);
            if (songList_Full[song].displayName != null) {
                displayNames.set(songList_Full[song].songName, songList_Full[song].displayName);
            }
            trace('Adding song ' + song + ' of ' + songList_Full.length + ': ' + songList_Full[song].songName);
            FlxG.log.notice('Adding song ' + song + ' of ' + songList_Full.length + ': ' + songList_Full[song].songName);

            var icon:HealthIcon = new HealthIcon(songList_Full[song].dadIcon);
            icon.sprTracker = jej;
            add(icon);
            iconArray.push(icon);

            if (songList_Full[song].songColor != null) {
                var meena:FlxColor = DumbUtil.makeColorFromRGB(songList_Full[song].songColor);
                bgColorList.push(meena);
            } else {
                var penis:SongColorInfo = songList_Full[song].songColorInfo;
                var meena:FlxColor = FlxColor.fromRGB(penis.red, penis.green, penis.blue, 255);
                bgColorList.push(meena);
            }

            var player2_Icon:String = songList_Full[song].dadIcon;
            opponentColors.set(player2_Icon, DumbUtil.iconColor(player2_Icon));
            var player1_Icon:String = songList_Full[song].bfIcon;
            bfColors.set(player1_Icon, DumbUtil.iconColor(player1_Icon));

            playerIcons_Dad.push(player2_Icon);
            playerIcons_Bf.push(player1_Icon);
            var instrumentalTrack:FlxSound = new FlxSound();
            instrumentalTrack.loadEmbedded(Paths.inst(Paths.formatToSongPath(songList_Full[song].songName)));
            instrumentalTrack.play();
            instrumentalTrack.pause(); // idk if thisll do much lmao
            instrumentals.push(instrumentalTrack);
            FlxG.sound.list.add(instrumentalTrack);
            var vocalTrack:FlxSound = new FlxSound();
            trace(Paths.inst(songList_Full[song].songName.toLowerCase()));
            if (songHasVoices[song]) vocalTrack.loadEmbedded(Paths.voices(Paths.formatToSongPath(songList_Full[song].songName))) else vocalTrack.loadEmbedded(Paths.sound("introGo"));
            vocalTrack.play();
            vocalTrack.pause();
            vocalTracks.push(vocalTrack);
            FlxG.sound.list.add(vocalTrack);
        }
        trace(opponentColors);
        trace(bfColors);
        eduardoIcon = new HealthIcon("eduardo");
        songBarBg = new FlxSprite(0, 0).loadGraphic(Paths.image("healthBar"));
        songBarBg.screenCenter(X);
        songBarBg.y = FlxG.height * 0.89;
        songBarBg.scrollFactor.set();
        add(songBarBg);
        songBarBg.kill();
        songBar = new FlxBar(songBarBg.x + 4, songBarBg.y + 4, RIGHT_TO_LEFT, Std.int(songBarBg.width - 8), Std.int(songBarBg.height - 8), this, "songPos", 0, 1);
        songBar.scrollFactor.set();
        songBar.createFilledBar(0xFF696969, 0xFFA6D388);
        add(songBar);
        //songBarBg.sprTracker = songBar;
        songBar.kill();
        bfIcon = new HealthIcon(playerIcons_Bf[0], true);
        bfIcon.y = songBar.y - (bfIcon.height / 2);
        add(bfIcon);
        bfIcon.kill();

        dadIcon = new HealthIcon(playerIcons_Dad[0]);
        dadIcon.y = songBar.y - (dadIcon.height / 2);
        dadIcon.animation.curAnim.curFrame = 1;
        add(dadIcon);
        eduardoIcon.y = dadIcon.y;
        add(eduardoIcon);
        eduardoIcon.kill();
        dadIcon.kill();

        timeHint = new HintMessageAsset("No song selected", 24, ClientPrefs.smallScreenFix);
        add(timeHint);
        add(timeHint.ADD_ME);
    }
    var displayThis:String = '';
    function playSong(SongData:OSTData) {
        grpSongs.forEach(function (alp:Alphabet) {
            if (alp.text != SongData.songName || (SongData.displayName != null && alp.text != SongData.displayName)) {
                alp.kill();
                iconArray[grpSongs.members.indexOf(alp)].kill();
            }
        });
        songBarBg.revive();
        songBar.revive();
        dadIcon.revive();
        bfIcon.revive();
        reloadIcons();
        if (SongData.iconChanges != null) {
            for (iconChange in SongData.iconChanges) {
                msTimes.push(iconChange.time_ms);
                chTargets.push(iconChange.changeTarget);
                newIcons.push(iconChange.newIcon);
                var ej:FlxColor = CoolUtil.dominantColor(new HealthIcon(iconChange.newIcon));
                var penis = ej.getColorInfo();
                if (iconChange.changeTarget == 'dad') {
                    opponentColors.set(iconChange.newIcon, ej);
                } else {
                    bfColors.set(iconChange.newIcon, ej);
                }
            }
        }
        if (SongData.songColor != null) {
            bg.setColor(DumbUtil.getBgRgbColor(SongData.songColor), true, 0.7);
        } else {
            var fatBitchAss = SongData.songColorInfo;
            bg.setColor(FlxColor.fromRGB(fatBitchAss.red, fatBitchAss.green, fatBitchAss.blue, 255), true, 0.7);
        }
        FlxG.sound.music.fadeOut(0.7, 0, { function(h:FlxTween) {
            if (displayNames.exists(SongData.songName)) displayThis = displayNames[SongData.songName] else displayThis = SongData.songName;
            FlxG.sound.list.members[FlxG.sound.list.members.indexOf(instrumentals[curSelected])].time = 0;
            FlxG.sound.list.members[FlxG.sound.list.members.indexOf(instrumentals[curSelected])].resume();
            curLength = FlxG.sound.list.members[FlxG.sound.list.members.indexOf(instrumentals[curSelected])].length;
            FlxG.sound.list.members[FlxG.sound.list.members.indexOf(instrumentals[curSelected])].onComplete = doStopThings;
            FlxG.sound.list.members[FlxG.sound.list.members.indexOf(vocalTracks[curSelected])].time = 0;
            FlxG.sound.list.members[FlxG.sound.list.members.indexOf(vocalTracks[curSelected])].resume();
            FlxG.sound.music.pause();
            playingSong = true;
        }});
    }
    var curDadColor:FlxColor;
    var curBfColor:FlxColor;

    function reloadIcons() {
        dadIcon.changeIcon(playerIcons_Dad[curSelected]);
        bfIcon.changeIcon(playerIcons_Bf[curSelected]);
        trace(dadIcon.getCharacter());
        trace(bfIcon.getCharacter());
        curDadColor = opponentColors[playerIcons_Dad[curSelected]];
        curBfColor = bfColors[playerIcons_Bf[curSelected]];
        songBar.createFilledBar(opponentColors[playerIcons_Dad[curSelected]], bfColors[playerIcons_Bf[curSelected]]);
        songBar.updateBar();
    }

    function doStopThings() {
        curSong = songList_Full[curSelected].songName;
        instrumentals[curSelected].pause();
        vocalTracks[curSelected].pause();
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
        curTime = 0;
        curLength = 0;
        bg.setColor(DumbUtil.makeColorFromRGB(songList_Full[0].songColor), true, 0.7);
        playingSong = false;
        if (msTimes.length >= 1) {
            msTimes = null;
            msTimes = [];
        }
        if (chTargets.length >= 1) {
            chTargets = null;
            chTargets = [];
        }
        if (newIcons.length >= 1) {
            newIcons = null;
            newIcons = [];
        }
        nextChangeID = 0;
    }
    var curTime:Float = 0;
    var curLength:Float = 0;
    /**This just switches icon to eduardo and back. lmao*/
    function doIconEgg() {
        if (bfIcon.getCharacter() == 'eduardo') {
            bfIcon.changeIcon(playerIcons_Bf[curSelected]);
            curBfColor = bfColors[bfIcon.getCharacter()];
            songBar.createFilledBar(opponentColors[dadIcon.getCharacter()], bfColors[bfIcon.getCharacter()]);
        } else {
            bfIcon.changeIcon('eduardo');
            var eduardoColors:Array<Int> = [17,
                113,
                43];
            curBfColor = DumbUtil.makeColorFromRGB(eduardoColors);
            songBar.createFilledBar(opponentColors[dadIcon.getCharacter()], DumbUtil.makeColorFromRGB(eduardoColors));
        }
    }
    function seekInSong(seek:Int) {
        instrumentals[curSelected].time += seek;
        if (!instOnly || hasVoices) vocalTracks[curSelected].time += seek;
    }

    function doIconStuff() {
        if (songPos >= 0.8) {
            if (dadIcon.sprTracker == null) dadIcon.animation.curAnim.curFrame = 1;
            if (eduardoIcon.alive) eduardoIcon.animation.curAnim.curFrame = 1;
        } else {
            if (dadIcon.sprTracker == null) dadIcon.animation.curAnim.curFrame = 0;
            if (eduardoIcon.alive) eduardoIcon.animation.curAnim.curFrame = 0;
        }
        if (songPos <= 0.2) {
            bfIcon.animation.curAnim.curFrame = 1;
            if (dadIcon.sprTracker == bfIcon) dadIcon.animation.curAnim.curFrame = 1;
        } else {
            bfIcon.animation.curAnim.curFrame = 0;
            if (dadIcon.sprTracker == bfIcon) dadIcon.animation.curAnim.curFrame = 0;
        }
        if (msTimes.length >= 1) {
            if (curTime >= msTimes[nextChangeID] && !JustChangedIcons) {
                JustChangedIcons = true;
                changeNewIcons(chTargets[chTargets.indexOf(chTargets[nextChangeID])], newIcons[newIcons.indexOf(newIcons[nextChangeID])], JustChangedIcons);
            }
            if (JustChangedIcons && curTime <= msTimes[nextChangeID]) {
                JustChangedIcons = false;
            }
        }
    }

    function changeNewIcons(Target:String, Icon:String, jci:Bool = false) {
        if (jci) {
            JustChangedIcons = false;
            if (Target == 'dad') {
                dadIcon.changeIcon(Icon);
                reloadBarColors(opponentColors[Icon]);
            }
            if (Target == 'bf') {
                bfIcon.changeIcon(Icon);
                reloadBarColors(null, bfColors[Icon]);
            }
        } else {
            trace("OOPS!!");
        }
    }

    function reloadBarColors(?NewDadColor:FlxColor, ?NewBfColor:FlxColor) { // BOTH ARE OPTIONAL IF CALLING WITHOUT COLOURS IS NECESSARY
        /*var newColor_Dad:FlxColor = 0xFF909090;
        var newColor_Bf:FlxColor = 0xFF696969;
        if (dadIcon.getCharacter() == playerIcons_Dad[curSelected]) {
            newColor_Dad = DumbUtil.makeColorFromRGB(opponentColors[dadIcon.getCharacter()]);
        } else {
            newColor_Dad = CoolUtil.dominantColor(dadIcon);
        }
        if (bfIcon.getCharacter() == playerIcons_Bf[curSelected]) {
            newColor_Bf = DumbUtil.makeColorFromRGB(opponentColors[bfIcon.getCharacter()]);
        } else {
            newColor_Bf = CoolUtil.dominantColor(bfIcon);
        } */
        var newColor_Dad:FlxColor;
        var newColor_Bf:FlxColor;
        if (NewDadColor != null) {
            newColor_Dad = NewDadColor;
            curDadColor = NewDadColor;
        } else {
            newColor_Dad = curDadColor;
        }
        if (NewBfColor != null) {
            newColor_Bf = NewBfColor;
            curBfColor = NewBfColor;
        } else {
            newColor_Bf = curBfColor;
        }
        
        songBar.createFilledBar(newColor_Dad, newColor_Bf);
        songBar.updateBar();
        nextChangeID++;
    }
    var nextChangeID:Int = 0;

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
    var JustChangedIcons:Bool = false;
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
            doIconStuff();
            curTime = FlxG.sound.list.members[FlxG.sound.list.members.indexOf(instrumentals[curSelected])].time;
            songPos = 1 - (curTime / curLength);
            if (controls.UI_LEFT_P) {
                seekInSong(-5000);
            }
            if (controls.UI_RIGHT_P) {
                seekInSong(5000);
            }
            if (controls.ACCEPT) {
                if (!FlxG.sound.list.members[FlxG.sound.list.members.indexOf(instrumentals[curSelected])].playing) FlxG.sound.list.members[FlxG.sound.list.members.indexOf(instrumentals[curSelected])].resume();
                else FlxG.sound.list.members[FlxG.sound.list.members.indexOf(instrumentals[curSelected])].pause();
                if (songHasVoices[curSelected]) {
                    if (!FlxG.sound.list.members[FlxG.sound.list.members.indexOf(vocalTracks[curSelected])].playing) FlxG.sound.list.members[FlxG.sound.list.members.indexOf(vocalTracks[curSelected])].resume();
                    else FlxG.sound.list.members[FlxG.sound.list.members.indexOf(vocalTracks[curSelected])].pause();
                }
            }
            if (controls.BACK) {
                doStopThings();
            }
            if (FlxG.keys.justPressed.NINE) {
                doIconEgg();
            }

            bfIcon.x = songBar.x + (songBar.width * (FlxMath.remapToRange(songBar.percent, 0, 100, 100, 0) * 0.01) - 26);
		    if (dadIcon.sprTracker == null) dadIcon.x = songBar.x + (songBar.width * (FlxMath.remapToRange(songBar.percent, 0, 100, 100, 0) * 0.01) - (dadIcon.width - 26));
            updateTimeHint();
            if (curSong.toLowerCase() == 'challeng-edd') {
                if (FlxStringUtil.formatTime(curTime / 1000) == "1:15") {
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
        var curTimeFormat = FlxStringUtil.formatTime(curTime / 1000);
        var lengthFormat = FlxStringUtil.formatTime(curLength / 1000);
        timeHint.setText("Currently playing: " + displayThis + " | " + curTimeFormat + " / " + lengthFormat);
    }
}