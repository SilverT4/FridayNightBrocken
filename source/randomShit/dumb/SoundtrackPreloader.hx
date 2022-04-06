package randomShit.dumb;

import randomShit.util.SoundtrackUtil;
import randomShit.util.HintMessageAsset;
import flixel.FlxG;
import flixel.system.FlxSound;
import randomShit.dumb.FunkyBackground;
import randomShit.dumb.SoundtrackMenu;
import randomShit.util.DumbUtil;
import flixel.util.FlxTimer;
using StringTools;

class SoundtrackPreloader extends MusicBeatState {
    var pissList:Array<OSTData> = [];
    var susMenu:SoundtrackMenu;
    var shitteroo:FunkyBackground;
    var pee:HintMessageAsset;
    var amongUs:FlxTimer;
    var poopy:SpinningIcon;
    var sex:Int = 0;
    var SWITCHIN:Bool = false;
    var fard:Bool = false;
    public function new() {
        super();
    }
    
    override function create() {
        trace("PISSIN!");
        shitteroo = new FunkyBackground();
        shitteroo.setColor(0xFF696969, false);
        add(shitteroo);
        pee = new HintMessageAsset("Just a second while we prepare to preload tracks...", 24, ClientPrefs.smallScreenFix);
        add(pee);
        add(pee.ADD_ME);
        poopy = new SpinningIcon(((ClientPrefs.smallScreenFix) ? TOP_RIGHT : BOTTOM_RIGHT));
        add(poopy);
        susMenu = new SoundtrackMenu();
        pissList = SoundtrackUtil.getSoundtrackList();
        fard = true;
        for (song in pissList) {
            #if debug
            FlxG.log.notice((pissList.indexOf(song) + 1) + ' of ' + pissList.length + ': Setting hasVoices of ' + song.songName + ' to ' + song.hasVoices);
            #end
            trace((pissList.indexOf(song) + 1) + ' of ' + pissList.length + ': Setting hasVoices of ' + song.songName + ' to ' + song.hasVoices);
            susMenu.songHasVoices.push(song.hasVoices);
        }
        amongUs = new FlxTimer();
        sex = 1;
        amongUs.start(2.5, function(amogus:FlxTimer) {
            var songShit = pissList[sex - 1];
            var dick = (songShit.displayName != null) ? songShit.displayName : songShit.songName;
            pee.setText("Now working on " + sex + " of " + pissList.length + ": " + dick);
            shitteroo.setColor(SoundtrackMenu.getSongColor(songShit), true, 0.5);
            var meena = SoundtrackMenu.getSongColor(songShit);
            susMenu.bgColorList.push(meena);
            susMenu.playerIcons_Bf.push(songShit.bfIcon);
            susMenu.playerIcons_Dad.push(songShit.dadIcon);
            susMenu.bfColors.set(songShit.bfIcon, DumbUtil.iconColor(songShit.bfIcon));
            susMenu.opponentColors.set(songShit.dadIcon, DumbUtil.iconColor(songShit.dadIcon));
            if (songShit.displayName != null) {
                susMenu.displayNames.set(songShit.songName, songShit.displayName);
            }
            var instrumentalTrack:FlxSound = new FlxSound();
            instrumentalTrack.loadEmbedded(Paths.inst(Paths.formatToSongPath(songShit.songName)));
            instrumentalTrack.play();
            instrumentalTrack.pause(); // idk if thisll do much lmao
            susMenu.instrumentals.push(instrumentalTrack);
            FlxG.sound.list.add(instrumentalTrack);
            var vocalTrack:FlxSound = new FlxSound();
            //trace(Paths.inst(songShit.songName.toLowerCase()));
            if (songShit.hasVoices) vocalTrack.loadEmbedded(Paths.voices(Paths.formatToSongPath(songShit.songName))) else vocalTrack.loadEmbedded(Paths.sound("introGo"));
            vocalTrack.play();
            vocalTrack.pause();
            susMenu.vocalTracks.push(vocalTrack);
            FlxG.sound.list.add(vocalTrack);
            susMenu.songPreloaded.push(true);
            pee.setText("Preloaded tracks for song " + sex + " of " + pissList.length);
        }, pissList.length);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (fard && sex == pissList.length && !SWITCHIN) {
            SWITCHIN = true;
            LoadingState.loadAndSwitchState(susMenu);
        }
    }
}