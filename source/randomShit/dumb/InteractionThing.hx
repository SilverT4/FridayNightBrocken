package randomShit.dumb;

import lime.app.Application;
import randomShit.util.ProfileUtil;
import flixel.FlxG;
import flixel.FlxState;
import MusicBeatState;
import DialogueBoxPsych;
import randomShit.oc.DevinsCharacterList;
import randomShit.util.SussyUtilities;
//import lime.app.Application;

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
        4 => "hobbies",
        5 => "know so much"
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
        if (character == 'snowdrift' && interaction == 5) return "WHAT" else return dialogueMapper[character][interaction];
    }

    /**This function gets the special "know so much" dialogue
        @since March 2022 (Emo Engine 0.1.2)*/
    public static function snowDriftKnows() {
        return getFunnyDialogue();
    }

    static function getFunnyDialogue() {
        //FUNNY SHIT
        var daComp = Application.current.meta["company"];
        var daExegg = Application.current.meta["file"];
        #if HAS_SYS_ENV_USER
        var sysName = Sys.systemName();
        var realUser = Sys.getEnv("USERNAME");
        var homeDir = #if windows "C:\\Users\\" + realUser #elseif macos "/Users/" + realUser #elseif linux Sys.getEnv("HOME") #end;
        var saveDir = #if windows "C:/Users/" + realUser + "/AppData/Roaming/" + daComp + "/" + daExegg + "/fridayNightBrocken" #elseif macos "/Users/" + realUser + "/Library/Application Support/" + daComp + "/" + daExegg + "/fridayNightBrocken" #elseif linux homeDir + "/" #end;
        var SUSSY_LIST:String = '';
        if (!SussyUtilities.FUNCTIONS_CEASED) {
            SUSSY_LIST = SussyUtilities.readExternalDirectory(saveDir);
        } else {
            SUSSY_LIST = "AMONG US!";
        }
        #end
        var playerName:String = '';
        if (TitleState.currentProfile != null) playerName = ProfileUtil.getPlayerName();
        else playerName = #if HAS_SYS_ENV_USER realUser; #else "buddy"; #end
        var funnyDialogue:DialogueFile = {
            dialogue: [
                {
                    portrait: "snowdrift",
                    expression: "awkward",
                    speed: 0.05,
                    boxState: "normal",
                    text: "How do I know so much?"
                }
            ],
            dialogueMusic: Paths.music("DaveDialogue"),
            musicFadeOut: true
        };
        var funnyDialogueTexts:Array<String> = [
            "Oh, " + playerName + ". You don't really need to\nknow how I know so much.",//0
            "But if you INSIST on knowing...",//1
            "I'll do my best to explain.",//2
            "So, I really know so much because I'm\nprogrammed in this game to know\nso much.",//3
            #if HAS_SYS_ENV_USER "Hell, I even know... Your " + Sys.systemName() + " username." #else "But I only know your profile name on web if\nyou provide me with it." #end,//4
            #if HAS_SYS_ENV_USER "Your " + sysName + " username is " + realUser + ", right?" #else "So you don't REALLY need to worry too much\nin that regard." #end,//5
            #if HAS_SYS_ENV_USER "Yeah, I know a lot. I even know your home directory folder.\n" + homeDir #else "Though I could access your browser history!" #end,//6
            #if HAS_SYS_ENV_USER "Though I won't go into your directories. That might get this\ngame quarantined by your PC's antivirus!" #else "Just kidding!! I don't have THAT much knowledge." #end,//7
            #if HAS_SYS_ENV_USER "What I CAN do though is list your save files.", #else "Let's just... Y'know. Talk about something else." #end//8
            #if HAS_SYS_ENV_USER
            "Just give me a sec...",//9
            "Anyway, that's enough about what I know. You wanna chat about somethin else now?"//10
            #end
        ];
        var funnyDialogueExps:Array<String> = [
            "awkward",
            "sussy",
            "excited",
            "awkward",
            #if HAS_SYS_ENV_USER "sussy" #else "awkward" #end,
            #if HAS_SYS_ENV_USER "sussy" #else "awkward" #end,
            "sussy",
            #if HAS_SYS_ENV_USER "awkward" #else "LOLJK" #end,
            #if HAS_SYS_ENV_USER "excited", #else "awkward" #end
            #if HAS_SYS_ENV_USER
            "filething",
            "awkward"
            #end
        ];
        var funnyDialoguePorts:Array<String> = [];
        for (kek in 0...#if sys 10 #else 8 #end) {
            funnyDialoguePorts.push("snowdrift");
        }
        #if HAS_SYS_ENV_USER
        if (!SussyUtilities.FUNCTIONS_CEASED) {
            funnyDialogueTexts.insert(10, SussyUtilities.readExternalDirectory(saveDir));
            funnyDialogueExps.insert(10, "talk");
            funnyDialoguePorts.insert(10, "tinyBlue");
        } else {
            funnyDialogueTexts.insert(10, "Oh, right. You disabled the sussy things in the game. Well, I can't show the list.");
            funnyDialogueExps.insert(10, "awkward");
            funnyDialoguePorts.insert(10, "snowdrift");
        }
        #end
        for (penis in 0...funnyDialogueTexts.length) {
            var penisDialogue:DialogueLine = {
                portrait: funnyDialoguePorts[penis],
                expression: funnyDialogueExps[penis],
                speed: 0.05,
                boxState: "normal",
                text: funnyDialogueTexts[penis]
            };
            funnyDialogue.dialogue.push(penisDialogue);
        }
        return funnyDialogue;
    }
}