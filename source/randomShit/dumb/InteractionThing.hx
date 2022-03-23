package randomShit.dumb;

import flixel.FlxG;
import flixel.FlxState;
import MusicBeatState;
import DialogueBoxPsych;
import randomShit.oc.DevinsCharacterList;

/**This contains some maps for dialogues. That's all.
    @since March 2022 (Emo Engine 0.1.1)*/
class InteractionDialogues {
    /**Dialogue mapper. This is used in the get json function.
        @since March 2022 (Emo Engine 0.1.1)*/
    public static var dialogueMapper:Map<String, Map<Int, String>> = [
        "snowdrift" => snowdriftDialogues,
        "blaze" => blazeDialogues,
        "nextor" => nextorDialogues
    ];
    /**Snowdrift's finally gonna talk outside of the options menu!! lmao
    @since March 2022 (Emo Engine 0.1.1)*/
    public static var snowdriftDialogues:Map<Int, String> = [
        0 => "greeting",
        1 => "NFTs",
        2 => "WDYD", // What Do You Do
        3 => "rap",
        4 => "hobbies"
    ];
    /**This map contains interaction file names for Blaze.
    @since March 2022 (Emo Engine 0.1.1)*/
    public static var blazeDialogues:Map<Int, String> = [
        0 => "greeting",
        1 => "NFTs",
        2 => "WDYD",
        3 => "rap",
        4 => "hobbies"
    ];
    /**This map contains interaction file names for Nextor.
    @since March 2022 (Emo Engine 0.1.1)*/
    public static var nextorDialogues:Map<Int, String> = [
        0 => "greeting",
        1 => "NFTs",
        2 => "WDYD",
        3 => "rap",
        4 => "hobbies"
    ];
    /**This function gets the dialogue JSON for an associated interaction.
        @since March 2022 (Emo Engine 0.1.1)*/
    public static function getCharDialogueJson(character:String, interaction:Int):String {
        return dialogueMapper[character][interaction];
    }
}