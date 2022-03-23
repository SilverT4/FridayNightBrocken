package options;

//import flixel.FlxG.save.data as BussySave;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG.save as Toilet;
import Alphabet;
import flixel.FlxG;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import MusicBeatState;
import randomShit.util.HintMessageAsset;
import Paths;
import AttachedSprite;
import HealthIcon;

using StringTools;
/**Gather your material gworls
@since Emo Engine 0.1.2 (March 2022)*/
class FavouriteCharas extends MusicBeatState {
    public function new() {
        // if (!BussySave.seenFavCharExp) openSubState(new FavouriteCharExplanation());
        super();
    }

    override function create() {
        if (!Toilet.data.seenFavCharExp) openSubState(new FavouriteCharExplanation());
    }
}

class FavouriteCharExplanation extends MusicBeatSubstate {
    var fartbar:FlxBar;
    var farts:Int = 0;

    public function new() {
        super();
    }

    override function create() {
        var bg = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0,0,0,128));
        add(bg);
        fartbar = new FlxBar(0, 0, LEFT_TO_RIGHT, 420, 42, this, 'farts', 0, 5, true);
        fartbar.createColoredEmptyBar(0x00000000, true, FlxColor.BLUE);
        add(fartbar);
    }
}