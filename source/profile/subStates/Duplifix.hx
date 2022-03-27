package profile.subStates;

import Alphabet;
import HealthIcon;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import randomShit.dumb.FunkyBackground;
import profile.FavUtil;
import randomShit.util.DumbUtil;
import randomShit.util.HintMessageAsset;
using StringTools;

/**Allows you to fix duplicates in your favourites.
    @since March 2022 (Emo Engine 0.1.2)*/
class Duplifix extends MusicBeatState {
    var initListAny:Array<String> = [];
    var initListBf:Array<String> = [];
    var initListGf:Array<String> = [];
    var initListOpp:Array<String> = [];
    var fixedListAny:Array<String> = [];
    var fixedListBf:Array<String> = [];
    var fixedListGf:Array<String> = [];
    var fixedListOpp:Array<String> = [];
    var yourSave:ProfileFavourite;

    public function new() {
        super();
        yourSave = FavUtil.getFavs();
        
    }
}