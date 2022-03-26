package randomShit.dumb;

import flixel.FlxSprite;
import Paths;
using StringTools; //just in case

/**Bambi minions from golden apple because yes
    @since March 2022 (Emo Engine 0.1.2), but earlier in Golden Apple.*/
class BambiMinion extends FlxSprite {
    var jej:String = 'poip'; // ANIM NAME IN XML
    var poop:Int = 12; // ANIM FRAMERATE
    var horny:String = 'cvm'; // ANIM NAME
    var figure_8:Bool = true; // ANIM LOOP
    var meme:String = 'minion';
    public var poiper:Bool = false;
    public function new() {
        super();
        trace('pubes');
        frames = Paths.getSparrowAtlas(meme, 'shared');
        animation.addByPrefix(horny, jej, poop, figure_8);
        animation.play(horny);
    }

    public function penis() {
        trace('a man of culture, i see');
        doSpeen();
    }

    function doSpeen() {
        //wip
    }
}