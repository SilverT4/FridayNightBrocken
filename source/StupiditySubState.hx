package;

import randomShit.util.DumbUtil;
import flixel.text.FlxText;
import randomShit.util.HintMessageAsset;
import randomShit.dumb.FunkyBackground;
import flixel.FlxG;
using StringTools;

class StupiditySubState extends MusicBeatSubstate {
    var theInst:String = "";
    var dumbassBack:FunkyBackground;
    var hintBot:HintMessageAsset;
    public function new() {
        super();
    }

    override function create() {
        dumbassBack = new FunkyBackground();
        dumbassBack.setColor(DumbUtil.iconColor(getRandomIcon()), false);
        add(dumbassBack);
        hintBot = new HintMessageAsset("Enter the name of a song.", 24, false);
        add(hintBot);
        add(hintBot.ADD_ME);
    }
    var iconList:Array<String> = [];
    function getRandomIcon() {
        trace("COLLECTING LIST!!");
        var h = #if sys sys.FileSystem.readDirectory("assets/images/icons") #else ["piss"] #end; // i need to figure out non-sys first
        for (icon in h) {
            var menace = icon.split('.');
            var pie = menace[0].split('-');
            pie.remove('icon');
            var hehe = pie.join('-');
            trace("adding icon " + (h.indexOf(icon) + 1) + " of " + h.length + ": " + hehe);
        }
        #if MODS_ALLOWED
        if (Paths.currentModDirectory.length > 1) {
            trace("PISS");
            var e = sys.FileSystem.readDirectory("mods/" + Paths.currentModDirectory + "/images/icons");
            for (icon in e) {
                var menace = icon.split('.');
                var pie = menace[0].split('-');
                pie.remove('icon');
                var hehe = pie.join('-');
                trace("adding icon " + (e.indexOf(icon) + 1) + " of " + e.length + " in " + Paths.currentModDirectory + ": " + hehe + "\n(Total icons: " + iconList.length + ")");
            }
        }
        var l = sys.FileSystem.readDirectory("mods/images/icons");
        for (icon in l) {
            var menace = icon.split('.');
            var pie = menace[0].split('-');
            pie.remove('icon');
            var hehe = pie.join('-');
            trace("adding icon " + (l.indexOf(icon) + 1) + " of " + l.length + " in base mods directory: " + hehe + "\n(Total icons: " + iconList.length + ")");
        }
        #end
        var p = FlxG.random.int(0, iconList.length - 1);
        trace(iconList[p] + " has been selected");
        return iconList[p];
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}