package;

import flixel.FlxState;
import MusicBeatState;

/**This is a "transition" class of sorts. Its only function is to allow a transition from an FlxState that *doesn't* extend MusicBeatState to one that does.
    @param LaunchThis The state to launch.
    @returns Well, nothing, really. It just switches you to the state specified.
    @since March 2022 (Emo Engine 0.1.2)*/
class MusicBeatLauncher extends MusicBeatState {

    public function new(NewState:MusicBeatState) {
        super();
        launchState(NewState);
    }
    public static function launchState(LaunchThis:MusicBeatState) {
        LoadingState.loadAndSwitchState(LaunchThis);
    }
}