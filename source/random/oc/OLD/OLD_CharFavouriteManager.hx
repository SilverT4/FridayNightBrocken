package random.oc.old;

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
/**A substate that allows you to modify the current values of your character's favourites. Utilizes as many of the imports above as possible.
    @since March 2022 (Emo Engine 0.1.1)
    @deprecated Gonna rework this, this is being moved to the OLD folder!*/
    class CharaFavouriteManager extends MusicBeatSubstate {
        public static var daFaves:CharFavourites; // maybe static might allow the value to *stay* after exit? idk
        static final exampleFaves:String = '{
            "favouriteColours": [
                "blue",
                "yellow"
            ],
            "favouriteAesthetics": [
                "neon",
                "pastel"
            ],
            "favouriteGames": [
                "Animal Crossing",
                "Mario"
            ],
            "favouriteMusicGenres": [
                "Rock",
                "Metal",
                "Pop"
            ],
            "favouriteArtists": [
                "Weezer",
                "CupcakKe"
            ]
        }'; // PLACEHOLDER, USED FOR THE CONVERT FUNCTION!!
        var colourBox:FlxUIInputText;
        var boxAesthetic:FlxUIInputText; //box aesthetic uwu
        var gamerBox:FlxUIInputText;
        var genreBox:FlxUIInputText;
        var artistBox:FlxUIInputText;
        var transparentBlackColour:Int = 0x6900000;
    
        public function new(curFaves:CharFavourites) {
            super();
            daFaves = curFaves;
            var bg:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, transparentBlackColour);
            bg.screenCenter();
            bg.scrollFactor.set();
            add(bg);
        }
    
        /**This allows you to convert your current variables to the typedef.*/
        public static function convertToNewFormat(col:Array<String>, aes:Array<String>, gam:Array<String>, mus:Array<String>, art:Array<String>):CharFavourites {
            var bean:CharFavourites;
            bean = cast Json.parse(exampleFaves); // JUST TO HAVE A PLACEHOLDER!
            bean.favouriteColours = col;
            bean.favouriteAesthetics = aes;
            bean.favouriteGames = gam;
            bean.favouriteMusicGenres = mus;
            bean.favouriteArtists = art;
            trace(bean);
            return bean;
        }
    
    }