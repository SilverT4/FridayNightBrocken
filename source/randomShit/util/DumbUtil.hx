package randomShit.util;

import profile.FavUtil;
import profile.FavUtil.ProfileFavourite;
import flixel.util.FlxColor;
import haxe.Exception;
import PlayState;
import Character;
import Boyfriend;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import sys.FileSystem;
import DialogueBoxPsych.DialogueFile;
import haxe.Json;

using StringTools;

/**A few dumb utils to save typing time, really. Idk
    @since Emo Engine 0.1.2 (March 2022)*/
class DumbUtil {
    // var PlayStation:PlayState;
    // static var BitchOne:Boyfriend;
    // static var BitchTwo:Character;

    public static function getBfAnim(AnimName:String):Bool {
        var PlayStation:PlayState = PlayState.instance;
        var BitchOne:Boyfriend = PlayStation.boyfriend;
        trace(BitchOne.animation.getByName(AnimName));
        if (BitchOne.animation.getByName(AnimName) != null) {
            return true;
        } else return false;
    }

    public static function getGfAnim(AnimName:String):Bool {
        var PlayStation:PlayState = PlayState.instance;
        var BitchTwo:Character = PlayStation.gf;
        trace(BitchTwo.animation.getByName(AnimName));
        if (BitchTwo.animation.getByName(AnimName) != null) {
            return true;
        } else return false;
    }

    public static function getDaddyAnim(AnimName:String):Bool {
        var PlayStation:PlayState = PlayState.instance;
        var BitchTwo:Character = PlayStation.dad;
        trace(BitchTwo.animation.getByName(AnimName));
        if (BitchTwo.animation.getByName(AnimName) != null) {
            return true;
        } else return false;
    }
    /**Returns a list of characters available in game, both base and mod.
        
    @returns An array of strings.
    
    (Example: `['bf', 'gf', 'dad', 'pico', 'mom', 'pico-player', 'mom-car', 'gf-car', 'gf-christmas', 'parents-christmas', 'bf-christmas', 'bf-car', 'cyan', 'meta', 'spooky', 'senpai', 'senpai-angry', 'spirit', 'monster', 'monster-christmas'])`
    */
    public static function getAllChars():Array<String> {
        var charList:Array<String> = [];
        var baseGameChars = FileSystem.readDirectory('assets/characters');
        for (i in 0...baseGameChars.length) {
            if (getExt(baseGameChars[i]) == 'json') charList.push(snipName(baseGameChars[i]));
        }
        #if MODS_ALLOWED
        var modCharBase = FileSystem.readDirectory('mods/characters');
        for (i in 0...modCharBase.length) {
            if (getExt(modCharBase[i]) == 'json') charList.push(snipName(modCharBase[i]));
        }
        if (Paths.currentModDirectory != '') {
            var modCharCur = FileSystem.readDirectory('mods/' + Paths.currentModDirectory + '/characters');
            for (i in 0...modCharCur.length) {
                if (getExt(modCharCur[i]) == 'json') charList.push(snipName(modCharCur[i]));
            }
        }
        #end
        return charList;
    }
    /**
    Gets the extension of a file.
    
    @param FileName The file
    @returns Its extension (or "no ext found" if no extension is found)*/
    public static function getExt(FileName:String):String {
        if (!FileName.contains('.')) {
            return 'no ext found';
        } else {
            var benis = FileName.split('.');
            return benis[1];
        }
    }

    /**Grabs the song list.
        @returns A list of songs
        @since March 2022 (Emo Engine 0.1.2)*/
    public static function getSongList() {
        var songReturn:Array<String> = [];
        for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			for (j in 0...leWeek.songs.length)
			{
				songReturn.push(leWeek.songs[j][0]);
			}
		}
        return songReturn;
    }

    public static function getSongIcons() {
        var iconReturn:Array<String> = [];
        for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			for (j in 0...leWeek.songs.length)
			{
				iconReturn.push(leWeek.songs[j][1]);
			}
		}
        return iconReturn;
    }

    /**Returns *only* the songs set in the favourite list.
        @returns Favourite songs list.
        @since March 2022 (Emo Engine 0.1.2)*/
    public static function getFavSongList() {
        var slist:Array<Dynamic> = [];
        var sjk:ProfileFavourite = FavUtil.getFavs();
        for (song in sjk.favouriteSongs) {
            slist.push([song, getIconFromWeek(song), getColourFromWeek(song)]);
        }
    }

    public static function getCharList() {
        var clist:Array<String> = [];
        var sfjd = FileSystem.readDirectory('assets/characters');
        for (ke in sfjd) {
            if (getExt(ke) == 'json') clist.push(snipName(ke));
        }
        #if MODS_ALLOWED
        if (Paths.currentModDirectory != '') {
            var ddeh = FileSystem.readDirectory('mods/' + Paths.currentModDirectory + '/characters');
            for (ef in ddeh) {
                if (getExt(ef) == 'json') clist.push(snipName(ef));
            }
        }
        var ehehef = FileSystem.readDirectory('mods/characters');
        for (sh in ehehef) {
            if (getExt(sh) == 'json') clist.push(snipName(sh));
        }
        #end
        return clist;
    }

    public static function getHealthIcons() {
        var eief:Array<String> = [];
        var ehe = getCharList();
        for (char in ehe) {
            var scoolbus:Dynamic = '';
            if (getExt(char) == 'json') scoolbus = cast Json.parse(getRawFile(Paths.characterJson(char)));
            eief.push(scoolbus.healthicon);
        }
        return eief;
    }

    public static function getIcons(CharArray:Array<String>) {
        var cjej:Dynamic = '';
        var jjj:Array<String> = [];
        for (char in CharArray) {
            cjej = cast Json.parse(getRawFile(Paths.characterJson(char)));
            jjj.push(cjej.healthicon);
        }
        return jjj;
    }

    public static function getBgRgbColor_Sub(Color:Array<Int>) {
        return randomShit.util.ColorUtil.rgbaToHex(Color[0], Color[1], Color[2], 105);
    }

    public static function parseChars(CharNames:Array<String>):Array<CharacterFile> {
        var lmao:Array<CharacterFile> = [];
        for (char in CharNames) {
            lmao.push(cast Json.parse(getRawFile(Paths.characterJson(char))));
        }
        return lmao;
    }

    static function getIconFromWeek(songName:String) {
        var kefj = WeekData.weeksList;
        for (week in kefj) {
            if (WeekData.weeksLoaded.exists(week)) {
                var jeje:WeekData = WeekData.weeksLoaded.get(week);
                if (jeje.songs.contains(songName)) {
                    for (eief in jeje.songs) {
                        if (eief[0] == songName) {
                            return eief[1];
                            break;
                        }
                    }
                }
            }
        }
        return null;
    }

    static function getColourFromWeek(songName:String) {
        var kefj = WeekData.weeksList;
        for (week in kefj) {
            if (WeekData.weeksLoaded.exists(week)) {
                var jeje:WeekData = WeekData.weeksLoaded.get(week);
                if (jeje.songs.contains(songName)) {
                    for (eief in jeje.songs) {
                        if (eief[0] == songName) {
                            return eief[2];
                            break;
                        }
                    }
                }
            }
        }
        return null;
    }
    /**Parse the JSON of a character without loading its sprites.
        
    @param JsonName the character json name
    @returns CharacterFile variable if found
    @throws Exception if no JSON is found
    @since March 2022 (Emo engine 0.1.2)*/
    public static function getCharFile(JsonName:String):Character.CharacterFile {
        if (actuallyExists(Paths.characterJson(JsonName))) return cast Json.parse(getRawFile(Paths.characterJson(JsonName)));
        else throw new haxe.Exception('no file found');
    }

    /**Gets the healthbar colours of a character in FlxColor format.
        
    @param Colours The colour array
    @returns An `FlxColor` object
    @since March 2022 (Emo Engine 0.1.2)*/
    public static function getFromRGB(Colours:Array<Int>):FlxColor {
        return FlxColor.fromRGB(Colours[0], Colours[1], Colours[2]);
    }

    /**@returns The raw data of the file
        @since March 2022 (Emo Engine 0.1.2)*/
    public static function getRawFile(FilePath:String):String {
        return sys.io.File.getContent(FilePath);
    }

    public static function actuallyExists(FilePath:String) {
        if (FileSystem.exists(FilePath)) return true
            else return false;
    }
    /**Gets the name of a file without its extension.
        
    @param FileName The file
    @returns Its name*/
    public static function snipName(FileName:String):String {
        var snipper = FileName.split('.');
        return snipper[0];
    }
    /**Easily parse Snowdrift Chatter files.
    
    @param Chatter The file to parse.
    @returns A DialogueFile variable with the chatter stuff*/
    public static function parseSnowdriftChatter(Chatter:String):DialogueFile {
        return cast Json.parse(Chatter);
    }

    public static function doBirthdayCheck() {
        if (TitleState.currentProfile != null) {
            var susDate = DevinsDateStuff.getTodaysDate();
            if (susDate[0] == TitleState.currentProfile.playerBirthday[0] && susDate[1] == TitleState.currentProfile.playerBirthday[1]) return true;
                else return false;
        }
        return false;
    }
}