package randomShit;

import flixel.FlxG;
import characters.Snowdrift;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import randomShit.util.HintMessageAsset;
import randomShit.dumb.FunkyBackground;
import flixel.util.FlxTimer;
using StringTools;

class SnowdriftThing extends MusicBeatState {
    var introText = ["Hi there! So sorry to interrupt you like this, bud.", "awkward-idle"];
    var doneText = ["Again, sorry for interrupting you! I'll get out of your way now.", "excite-talk"];
    var NEWSEL_TEXTS:Array<Dynamic> = [
        ["I just wanted to let you know about a new update to the\ncharacter select screen.", "talk-idle"],
        ["Now, let me check your settings real quick...", "awkward-idle"],
        ["This update completely changes the design of\nthe character select screen.", "sus-idle"],
        ["You can now scroll through your characters using the arrow keys,\nand confirm your choice before you play a song.", "sus-idle"],
    ];
    var pissLength:Int = 0;
    var dialogueMapper:Map<String, Array<Dynamic>> = [];
    var playerName = 'bud';
    var showMe:Array<Dynamic>;
    var curDialogue:Int = 0;
    var pie:FunkyBackground; //mm pie
    var snowman:Snowdrift;
    var jerma:FlxText;
    var weShowin:String = '';
    public function new(DiaToShow:String) {
        super();
        dialogueMapper.set("newsel", NEWSEL_TEXTS);
        if (TitleState.currentProfile != null) {
            playerName = TitleState.currentProfile.profileName;
        }
        introText[0].replace("bud", playerName);
        DialCurrent = introText;
        if (dialogueMapper.exists(DiaToShow)) {
            showMe = dialogueMapper[DiaToShow];
            if (DiaToShow == "newsel") {
                var pee = (ClientPrefs.skipCharaSelect) ? ["I see that you've set the game to skip the character select screen.\nThis info won't really affect you too much then.", "awkward-idle"] : ["Ah, you haven't skipped the character select screen. Well then, I suggest you pay attention.", "awkward-idle"];
                showMe.insert(2, pee);
                var poo = (ClientPrefs.skipCharaSelect) ? ["I hope you give it a try some time, " + playerName + "!", "excited-idle"] : ["Hope it helps you out!", "excited-idle"];
                showMe.push(poo);
            }
            pissLength = showMe.length;
        }
    }
    var DialCurrent:Array<Dynamic> = [];

    override function create() {
        pie = new FunkyBackground();
        pie.setColor(0xFFAACCFF, false);
        add(pie);
        jerma = new FlxText(0, 0, 0, "Penis", 24);
        jerma.setFormat("VCR OSD Mono", 24, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
        jerma.screenCenter();
        jerma.updateHitbox();
        add(jerma);
        snowman = new Snowdrift(1014, 431);
        snowman.setGraphicSize((Std.int(snowman.width * 0.7)));
        snowman.switchAnim("awkward-idle");
        add(snowman);
    }
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.ACCEPT) {
            if (curDialogue < pissLength && (showMe != null && showMe.contains(DialCurrent))) advanceDialogue() else {
                if (showMe != null && curDialogue >= pissLength) doExitShit();
                else DialCurrent = showMe[0];
            }
        }
        if (DialCurrent.length > 1) {
            if (jerma != null && jerma.text != DialCurrent[0]) {
                jerma.text = DialCurrent[0];
                jerma.fieldWidth = 0;
                jerma.updateHitbox();
            }
            if (snowman != null && snowman.animation.curAnim.name != DialCurrent[1]) snowman.switchAnim(DialCurrent[1]);
        }
    }

    function doExitShit() {
        if (weShowin == "newsel") {
            FlxG.save.data.seenNewCharSelectMsg = true;
            DialCurrent = doneText;
        }
        new FlxTimer().start(5, function(myBallsAreBiggerThanYours:FlxTimer) {
            LoadingState.loadAndSwitchState(new MainMenuState());
        });
    }

    function advanceDialogue() {
        curDialogue += 1;
        DialCurrent = showMe[curDialogue];
    }
}