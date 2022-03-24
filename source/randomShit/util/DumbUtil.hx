package randomShit.util;

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

    /**Parse the JSON of a character without loading its sprites.
        
    @param JsonName the character json name
    @returns CharacterFile variable if found
    @throws Exception if no JSON is found
    @since March 2022 (Emo engine 0.1.2)*/
    public static function getCharFile(JsonName:String):Character.CharacterFile {
        if (Paths.fileExists(Paths.characterJson(JsonName), openfl.utils.AssetType.TEXT, false)) return cast Json.parse(getRawFile(Paths.characterJson(JsonName)));
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