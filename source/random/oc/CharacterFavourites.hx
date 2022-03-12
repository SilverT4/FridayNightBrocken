package random.oc;

import haxe.Json;
import flixel.FlxSprite;
import flixel.FlxSubState;
import MusicBeatSubstate;
import random.oc.DevinsCharacterList;
import flixel.FlxG;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltipManager;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.util.FlxColor;

/**This typedef contains the same vars as the original favourite vars in OCThing. Just a bit cleaner. I hope.
@param favouriteColours A list of favourite colours.
@param favouriteAesthetics A list of favourite aesthetics (like grunge, neon, etc.)
@param favouriteGames A list of favourite games.
@param favouriteMusicGenres A list of favourite genres of music.
@param favouriteArtists A list of favourite artists.
@since March 2022 (Emo Engine 0.1.1)*/
typedef CharFavourites = {
    var favouriteColours:Array<String>; // For if a character's got some favourite colours
    var favouriteAesthetics:Array<String>; // Ditto, but for aesthetics (like grunge, neon, etc.)
    var favouriteGames:Array<String>; // Ditto, but for games
    var favouriteMusicGenres:Array<String>; // Ditto, but for genres of music.
    var favouriteArtists:Array<String>; // Ditto, but for artists
}

class CharacterFavouritesSubstate extends MusicBeatSubstate {
    var nowListenUp:String = '{
        "favouriteColours": [
            "green",
            "blue"
        ],
        "favouriteAesthetics": [
            "grunge",
            "neon"
        ],
        "favouriteGames": [
            "Animal Crossing",
            "Mario Kart"
        ],
        "favouriteMusicGenres": [
            "rock",
            "lofi"
        ],
        "favouriteArtists": [
            "CupcakKe",
            "Fall Out Boy"
        ]
    }';
    var heresDaStory:CharFavourites;
    var aboutALittleGuy:FlxUITabMenu;
    var thatLivesInABlueWorld:FlxUI;
    var andAllDayAndAllNight:Array<FlxUIInputText> = [];
    var andEverythingHeSees:Array<String> = []; // GAMES
    var isJustBlue:Array<String> = []; // COLOURS
    var likeHim:Array<String> = []; // ARTISTS
    var insideAndOutside:Array<String> = []; // AESTHETICS
    var blueHisHouse:Array<String> = []; // MUSIC GENRES
    var withABlueLittleWindow:FlxUI; // I NEED TO MAKE SEVERAL TABS FOR THIS EDITOR. LMAO (COLOURS)
    var andABlueCorvette:FlxUI; // MUSIC GENRES
    var andEverythingIsBlue:FlxUI; // AESTHETICS
    var forHim:FlxUI; // GAMES
    var andHimself:FlxUI; // ARTISTS
    var andEverybodyAround:FlxSprite; // BG

    public function new (?curFaves:CharFavourites) {
        super();
        if (curFaves != null) {
            heresDaStory = curFaves;
            trace(heresDaStory);
        } else {
            heresDaStory = cast Json.parse(nowListenUp);
            trace(heresDaStory);
            trace('Quick note', 'You either had no favourites, or you just haven\'t converted them.\nYou\'re starting fresh here.');
        }
    }

    override function create() {
        trace('penis');
        andEverybodyAround = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 0, 255, 195));
        add(andEverybodyAround);
    }
}