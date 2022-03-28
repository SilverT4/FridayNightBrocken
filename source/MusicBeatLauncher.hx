package;

//import flixel.FlxState;
import MusicBeatState;

/**This is a "transition" class of sorts. Its only function is to allow a transition from an FlxState that *doesn't* extend MusicBeatState to one that does.
    @param LaunchThis The state to launch.
    @returns Well, nothing, really. It just switches you to the state specified.
    @since March 2022 (Emo Engine 0.1.2)*/
class MusicBeatLauncher extends MusicBeatState {
    var NewState:Dynamic;
    public function new(Newstate:MusicBeatState) {
        super();
        if (PlayerSettings.player1 == null) {
            PlayerSettings.init(); // JUST IN CASE!!
            #if debug flixel.FlxG.log.add('HEY!! Just a very quick heads up: You forgot to initalise the player settings! The launcher you called has done it for you, but please be careful in the future!'); #end
        }
        NewState = Newstate;
    }

    override function create() {
        launchState(NewState);
    }
    public static function launchState(LaunchThis:MusicBeatState) {
        LoadingState.loadAndSwitchState(LaunchThis);
    }
}