package profile;

import flixel.FlxG; // for save

using StringTools;

typedef ProfileFavourite = {
    var favouriteSongs:Array<String>;
    var favouriteChars:FavouriteCharList;
}
typedef FavouriteCharList = {
    var opponent:Array<String>;
    var bf:Array<String>;
    var gf:Array<String>;
    var any:Array<String>;
}
/**Utility class for managing favourites.
    @since March 2022 (Emo Engine 0.1.2)*/
class FavUtil {
    public static var favourites:ProfileFavourite;
    static var cannotKeepFavs:Array<String> = [
        'Guest',
        'placeholderprofile'
    ];

    public static function initFavs() {
        trace('INIT FAVS');
        favourites = {
            favouriteSongs: [
                "test"
            ],
            favouriteChars: {
                opponent: [
                    "dad",
                    "pico"
                ],
                bf: [
                    "bf",
                    "cyan"
                ],
                gf: [
                    "gf-but-devin",
                    "gf-but-bosip"
                ],
                any: [
                    "snowdrift"
                ]
            }
        };
        FlxG.save.data.profileFavourites = favourites;
    }
    static var TEMP_SONGS:Array<String>;
    public static function getFavs() {
        if (FlxG.save.data.profileFavourites != null) {
            if (FlxG.save.data.profileFavourites.favouriteChars is Array) {
                TEMP_SONGS = FlxG.save.data.profileFavourites.favouriteSongs;
                FlxG.save.data.profileFavourites = null;
                initFavs();
                FlxG.save.data.profileFavourites.favouriteSongs = TEMP_SONGS;
            }
            return FlxG.save.data.profileFavourites;
        } else {
            #if debug
            FlxG.log.error('NO FAVOURITES?');
            #end
            if (TitleState.currentProfile != null) {
                if (!cannotKeepFavs.contains(TitleState.currentProfile.profileName)) {
                    initFavs();
                } else {
                    trace('oh, we cant make favs for this profile');
                    FlxG.sound.play(Paths.sound('errorOops'));
                }
            }
            return null;
        }
    }

    public static function setFavs(newSongList:Array<String>, newCharList:FavouriteCharList) {
        favourites = getFavs();
        favourites.favouriteSongs = newSongList;
        favourites.favouriteChars = newCharList;
        FlxG.save.data.profileFavourites = favourites;
        FlxG.save.flush();
        FlxG.log.add("Saved favourites!");
    }
}