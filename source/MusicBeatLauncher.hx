package;

//import flixel.FlxState;
import MusicBeatState;

/**This is a "transition" class of sorts. Its only function is to allow a transition from an FlxState that *doesn't* extend MusicBeatState to one that does.
    @param LaunchThis The state to launch.
    @returns Well, nothing, really. It just switches you to the state specified.
    @since March 2022 (Emo Engine 0.1.2)*/
class MusicBeatLauncher extends MusicBeatState {
    var NewState:Dynamic;
    var hadToInit:Bool = false;
    public function new(Newstate:MusicBeatState) {
        super();
        if (PlayerSettings.player1 == null) {
            hadToInit = true;
            if (TitleState.currentProfile != null) {
                flixel.FlxG.save.bind(TitleState.currentProfile.saveName, "fridayNightBrocken");
                var dumbass = TitleState.currentProfile.profileName;
                Achievements.achievementsStuff.push(["Happy Birthday!",				"Happy birthday, " + dumbass + "!\nCheck the options menu for a surprise.",  'birthday',	true]); // just to have this. lmao
            } else {
                flixel.FlxG.save.bind("funkin", "ninjamuffin99");
            }
            PlayerSettings.init(); // JUST IN CASE!!
            ClientPrefs.loadPrefs();
            #if debug flixel.FlxG.log.add('HEY!! Just a very quick heads up: You forgot to initalise the player settings! The launcher you called has done it for you, but please be careful in the future!'); #end
        }
        NewState = Newstate;
    }

    override function create() {
        if (hadToInit) {
            var speen:flixel.FlxSprite = new flixel.FlxSprite(flixel.FlxG.width - 48, 0);
            speen.frames = Paths.getSparrowAtlas("editor/speen", "preload");
            speen.animation.addByPrefix("speen", "spinner go brr", 30, true);
            speen.animation.play("speen");
            var fuckinShit:randomShit.util.HintMessageAsset = new randomShit.util.HintMessageAsset("Hey! Quick heads up: Player settings weren't initialised. That's been done for you now by this launcher state.", 12, ClientPrefs.smallScreenFix);
            add(fuckinShit);
            add(fuckinShit.ADD_ME);
            add(speen);
            new flixel.util.FlxTimer().start(3, function(fuck:flixel.util.FlxTimer) {
                launchState(NewState);
            });
        } else {
            launchState(NewState);
        }
    }
    public static function launchState(LaunchThis:MusicBeatState) {
        LoadingState.loadAndSwitchState(LaunchThis);
    }
}