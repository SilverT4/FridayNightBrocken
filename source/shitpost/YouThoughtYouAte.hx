package shitpost;

import flixel.util.FlxTimer;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import Boyfriend as Bitch;
import shitpost.Vanessa;

using StringTools;
/**THE GAME JUST SHIT ITSELF.
    CONGRATULATIONS.
    @since YOU CLOWNED`*/
class ShittingAndFarting extends FlxState {
    var whiteWoman:Vanessa;

    public function new() {
        super();
        FlxG.sound.music.stop();
        whiteWoman = new Vanessa(0,0);
        whiteWoman.setGraphicSize(Std.int(FlxG.width), Std.int(FlxG.height));
        whiteWoman.screenCenter();
        add(whiteWoman);
        FlxG.sound.play(Paths.sound('jumpedYaMom'));
        whiteWoman.whiteWomanJumpscare();
    }

    override function update(elapsed:Float) {
        if (whiteWoman != null) {
            whiteWoman.update(elapsed);
            if (whiteWoman.animation.curAnim.name == 'vanny' && whiteWoman.animation.curAnim.finished && !whiteWoman.readyToCrash) {
                whiteWoman.readyToCrash = true;
                new FlxTimer().start(0.5, function(tmr:FlxTimer) {
                    whiteWoman.crashGame();
                });
            }
        }
    }
}
/**You thought you ate 💀💀💀
@since when?!?!?!??!*/
class YouThoughtYouAte extends MusicBeatState {
    var fuckingIdiots:FlxSprite;

    public function new() {
        super();
        FlxG.sound.music.resume();
        FlxG.sound.playMusic(Paths.music('clownTheme'));
        fuckingIdiots = new FlxSprite(0).loadGraphic(Paths.image('fuckYou'));
        fuckingIdiots.scrollFactor.set();
        fuckingIdiots.screenCenter();
        add(fuckingIdiots);
    }
    override function create() {
        new FlxTimer().start(10, whiteWoman);
    }
    function whiteWoman(egg:FlxTimer = null) {
        FlxG.switchState(new shitpost.ShittingAndFarting());
    }
}