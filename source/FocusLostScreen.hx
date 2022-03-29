package;
import MusicBeatSubstate;
import randomShit.dumb.FunkyBackground;
import randomShit.util.HintMessageAsset;
import flixel.FlxG;
import PlayState;
import randomShit.util.DumbUtil;
using StringTools;

/**A basic "You've alt-tabbed" screen. Background colour will be set to the BF's health colour if focus was lost in a song, otherwise a random colour is used.
    @since March 2022 (Emo Engine 0.2.0)*/
class FocusLostScreen extends MusicBeatSubstate {
    var bg:FunkyBackground;
    var hint:HintMessageAsset;
    var backColor:flixel.util.FlxColor;
    public static var isOpen:Bool = false;
    static var justFocused:Bool = false;
    public function new() {
        if (PlayState.SONG != null) {
            backColor = DumbUtil.getBarColor(PlayState.SONG.player1); // use player1
        } else {
            backColor = FlxG.random.color(0xFF000000, 0xFFFFFFFF);
        }
        super();
    }

    override function create() {
        isOpen = true;
        bg = new FunkyBackground();
        bg.setColor(backColor, false);
        add(bg);
        hint = new HintMessageAsset("Your game window is currently unfocused. Switch to the game to dismiss this message.", 24, openfl.system.Capabilities.screenResolutionY <= 768);
        add(hint);
        add(hint.ADD_ME);
        switch (ClientPrefs.focusLoseSound) {
            case 'FNF Original':
                FlxG.sound.play(Paths.soundRandom("missnoteOG", 1, 3));
            case 'Jiafei Scream':
                FlxG.sound.play(Paths.soundRandom("missnote", 1, 3));
        }
    }

    public static function weGotFocus() {
        justFocused = true;
    }

    override function update(elapsed:Float) {
        if (justFocused) {
            justFocused = false;
            isOpen = false;
            FlxG.sound.play(Paths.sound("confirmMenu"), 1, false, null, true, function() {
                close();
            });
            //close();
        }
        super.update(elapsed);
    }
}