package randomShit.util;

import flixel.math.FlxRandom;
import lime.app.Application;
using StringTools;

/**This class handles setting a random title for the window every time you launch it. It's also the first new thing with the new name for this repo: Stupidity Engine.
    @since April 2022 (Stupidity Engine 0.2.1)*/
class TitleShit {
    public static var characterNameList:Array<String> = [
        "Devin",
        "Alphagolem",
        "Blaze",
        "Blitz",
        "Sus",
        "GlowStrike", // older oc check lmao
        "Metabee",
        "Pissin"
    ];
    public static var pubic:String = '';
    public static function randomTitle() {
        var peen = new FlxRandom();
        var piss = peen.int(0, characterNameList.length - 1);
        pubic = characterNameList[piss];
        if (Application.current != null) {
            Application.current.window.title = "Friday Night Funkin': " + pubic + " Engine (Old Branch)";
        }
    }
}