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
        poopy = new SpinningIcon(((ClientPrefs.smallScreenFix) ? TOP_LEFT : BOTTOM_LEFT));
        add(poopy);
        pee.moveForSpinner();
        //susMenu = new SoundtrackMenu();
        pissList = SoundtrackUtil.getSoundtrackList();
        //susMenu.songList_Full = pissList;
        fard = true;
        amongUs = new FlxTimer();
        sex = 1;
        amongUs.start(0.1, function(amogus:FlxTimer) {
            var songShit = pissList[sex - 1];
            var dick = (songShit.displayName != null) ? songShit.displayName : songShit.songName;
            pee.setText("Now working on " + sex + " of " + pissList.length + ": " + dick);
            shitteroo.setColor(SoundtrackMenu.getSongColor(songShit), true, 0.5);
            pee.setText("Preloaded tracks for song " + sex + " of " + pissList.length + ': $dick');
            sex++;
        }, pissList.length);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (fard && sex == pissList.length && !SWITCHIN) {
            SWITCHIN = true;
            LoadingState.loadAndSwitchState(new SoundtrackMenu());
        }
    }
}