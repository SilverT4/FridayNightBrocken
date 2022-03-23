package randomShit.util;

import randomShit.oc.OCEditorState;
import sys.io.File;
import sys.FileSystem;
import Paths; // WE MIGHT NEED IT!
import sys.io.Process;
import haxe.Json;
import randomShit.oc.DevinsCharacterList;
import randomShit.oc.Pronouns;
import randomShit.oc.CharacterFavourites;

using StringTools;

typedef UnsetType = {
    var lmao:String;
}
/**A bunch of additional file utilities that I'm creating for my stuff.
@since March 2022 (Emo Engine 0.1.1)*/
class DevinsFileUtils {
    static final commonPaths:Map<String, String> = [
        "oc" => "assets/OC/",
        "dialogue" => "assets/OC/dialogue/",
        "charImage" => "assets/images/myOCs/",
        "pronounSet" => "assets/OC/pronouns/",
    ]; // I PROMISE THE OC FOLDER WON'T BE SO MESSY IN THE FUTURE!!
    static final oc:String = 'oc';
    static final dia:String = 'dialogue';
    static final chim:String = 'charImage';
    static final pronSet:String = 'pronounSet';
    static final HaxeStopBitching:String = '{
        "dialogueFileName": "bussy",
        "characterNames": [
            "bussy",
            "shart"
        ]
    }';
    static final HaxeStopBitching_ElectricBoogaloo:String = '{
        "FilePath": "YourMom"
    }';
    /**This function will return the OC Info file contents.*/
    public static function ocInfo(chara:String):OCThing {
        var charStuff:OCThing = cast Json.parse(HaxeStopBitching);
        trace('GRABBING INFO FOR ' + chara + ' NOW!!');
        if (checkExisting(chara, oc)) {
            charStuff = jussyGet(chara, oc);
        }
        return charStuff;
    }
    public static function ocDialogue(CharName:String, FileName:String):OCDiaThingy {
        var diarrhea:OCDiaThingy = cast Json.parse(HaxeStopBitching_ElectricBoogaloo); // I HATE HOW WEIRD THIS WORD IS TO SPELL!!
        if (checkExisting(FileName, dia, CharName)) {
            diarrhea = jussyGet(FileName, dia, CharName);
        }
        return diarrhea;
    }
    public static function checkExisting(FileName:String, FileType:String, ?CharDiaName:String, ?ExpectedResult:Bool = true) {
        var theResult:Bool = false;
        var prelimResult:Bool = false;
        switch (FileType) {
            case oc:
                if (FileSystem.exists(commonPaths[oc] + FileName + '.json')) {
                    prelimResult = true;
                }
            case dia:
                if (FileSystem.exists(commonPaths[dia] + CharDiaName + '/' + FileName + '.json')) {
                    prelimResult = true;
                }
            case pronSet:
                if (FileSystem.exists(commonPaths[pronSet] + FileName + '.json')) {
                    prelimResult = true;
                }
            case chim:
                if (FileSystem.exists(commonPaths[chim] + FileName + '.png')) {
                    prelimResult = true;
                }
        }
        if (ExpectedResult != null) {
            if (ExpectedResult && prelimResult) theResult = true
                 else if (ExpectedResult && !prelimResult) theResult = false
                    else if (!ExpectedResult && prelimResult) theResult = false
                        else theResult = true; // IF BOTH ARE FALSE!!
        } else {
            theResult = prelimResult;
        }
        return theResult;
    }
    static inline function jussyGet(FileName:String, FileType:String, ?CharDiaName:String):Dynamic {
        var cumshot:Dynamic = 69;
        switch (FileType) {
            case oc:
                trace('GOTCHA.');
                cumshot = jussyParse(commonPaths[oc] + FileName);
            case dia:
                trace('OOOO TALKATIVE EH LMAO');
                cumshot = jussyParse(commonPaths[dia] + CharDiaName + '/' + FileName);
            case pronSet:
                cumshot = pronounParser(FileName);
        }
        return cumshot;
    }

    inline static function jussyParse(Jussy:String):Dynamic {
        var cum:Dynamic;
        cum = cast Json.parse(Jussy + '.json');
        return cum;
    }

    inline static function pronounParser(PronounSet:String):Pronoun {
        var bruh:Pronoun;
        bruh = jussyParse(commonPaths[pronSet] + PronounSet);
        return bruh;
    }

    public static function parseJsonString(JSON:String):Dynamic {
        return cast Json.parse(JSON);
    }
}