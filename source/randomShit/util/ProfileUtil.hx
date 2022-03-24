package randomShit.util;

import openfl.events.IOErrorEvent;
import openfl.events.Event;
import openfl.net.FileReference;
import ProfileThingy.ProfileShit;
import sys.io.File as ProFile; // HAHA, GET IT? yeah. that wasn't really funny, ik
import sys.FileSystem as SusSystem;
import randomShit.util.ProfileException;
import haxe.Json as JFK;

using StringTools;

typedef ProfileUtil_Defs = {
    var doesExist:Bool;
    var jsonPath:String; // this gets set when getStatusOfJson finds the profile json
}
/**Utility class for handling profiles. This will be used in place of some of the existing code to *hopefully* clean that up a little bit.
    
    @since March 2022 (Emo Engine 0.1.2)*/
class ProfileUtil {
    static inline final JSON = '.json';

    static inline final PROFILES = 'profiles/';

    static var ProfileDir_Exists:Bool = SusSystem.exists('profiles');
    static var theProfile:ProfileShit;
    public static function getProfileData(ProfileName:String) {
        if (ProfileDir_Exists) {
            if (getStatusOfJson(ProfileName).doesExist) {
                return cast JFK.parse(ProFile.getContent(PROFILES + ProfileName + JSON));
            } else {
                throw new ProfileException("Profile with name " + ProfileName + " does not exist!!");
            }
            return JFK.parse('{ profileName: "placeholder", playerBirthday: ' + randomShit.util.DevinsDateStuff.getTodaysDate() + ', saveName: "temp", profileIcon: "bf", comment: "sex" }');
        } else {
            flixel.FlxG.log.warn('Profile directory does not exist! Creating now!!');
            SusSystem.createDirectory('profiles');
            return JFK.parse('{ profileName: "placeholder", playerBirthday: ' + randomShit.util.DevinsDateStuff.getTodaysDate() + ', saveName: "temp", profileIcon: "bf", comment: "sex" }');
        }
    }

    static function getStatusOfJson(JsonName:String) {
        if (SusSystem.exists(PROFILES + JsonName + JSON)) {
            theProfile = cast JFK.parse(ProFile.getContent(PROFILES + JsonName + JSON));
            return {
                doesExist: true,
                jsonPath: PROFILES + JsonName + JSON
            };
        } else {
            return {
                doesExist: false,
                jsonPath: ''
            };
        }
    }

    public static function getProfileList() {
        var profList:Array<String> = [];
        if (ProfileDir_Exists) {
            profList = SusSystem.readDirectory('profiles');
            for (prof in profList) {
                prof = prof.substr(0, prof.length - 5);
            }
        }
        if (profList.length >= 1) return profList;
        else return ['no profiles'];
    }

    public static function updateExistingSave(saveName:String, ProfileInfo:ProfileShit) {
        if (getStatusOfJson(saveName).doesExist) {
            ProFile.saveContent(PROFILES + saveName + JSON, JFK.stringify(ProfileInfo, "\t"));
        } else {
            flixel.FlxG.log.error('PROFILE DOES NOT EXIST??????');
        }
    }
    static var beb:FileReference;
    public static function saveNewProfile(SaveInfo:ProfileShit, ProfileName:String) {
        if (ProfileDir_Exists) {
            beb = new FileReference();
            beb.addEventListener(Event.SELECT, onSaveComplete);
            beb.addEventListener(Event.CANCEL, onSaveCancel);
            beb.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            beb.save(JFK.stringify(SaveInfo, "\t"), 'profiles/' + ProfileName + JSON);
        } else {
            flixel.FlxG.log.warn('Profile directory does not exist! Creating now!!');
            SusSystem.createDirectory('profiles');
            beb = new FileReference();
            beb.addEventListener(Event.SELECT, onSaveComplete);
            beb.addEventListener(Event.CANCEL, onSaveCancel);
            beb.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            beb.save(JFK.stringify(SaveInfo, "\t"), 'profiles/' + ProfileName + JSON);
        }
    }

    static function onSaveComplete(_):Void {
        #if debug
        flixel.FlxG.log.notice('File saved to: ' + @:privateAccess beb.__path);
        #end
        beb.removeEventListener(Event.SELECT, onSaveComplete);
        beb.removeEventListener(Event.CANCEL, onSaveCancel);
        beb.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        beb = null;
    }

    static function onSaveCancel(_):Void {
        beb.removeEventListener(Event.SELECT, onSaveComplete);
        beb.removeEventListener(Event.CANCEL, onSaveCancel);
        beb.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        beb = null;
        trace('e');
    }

    static function onSaveError(_):Void {
        beb.removeEventListener(Event.SELECT, onSaveComplete);
        beb.removeEventListener(Event.CANCEL, onSaveCancel);
        beb.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
        beb = null;
        #if debug
        flixel.FlxG.log.error('Something went wrong, please try again!!');
        #end
    }
}