package;

import flixel.FlxG;
import Boyfriend;
import randomShit.util.HintMessageAsset;
import flixel.FlxSprite;
using StringTools;

/**This substate allows you to preview the character you're selecting. You can press Y to confirm or N to go back. (You can change this!)
    @since April 2022 (Stupidity Engine 0.2.1)*/
class CharacterPreview extends MusicBeatSubstate {
    var piss:FlxSprite;
    var hint:HintMessageAsset;
    var preview:Boyfriend;
    var pissy:String = 'bf';
    var poopy:String = 'hey';
    var farding:Bool = true;
    public function new(characterName:String = 'bf', hasHey:Bool = true, heyAnim:String = 'hey') {
        super();
        pissy = characterName;
        farding = hasHey;
        poopy = (farding) ? heyAnim : "singUP";
        piss = new FlxSprite();
        piss.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        piss.alpha = 0.6;
        add(piss);
        hint = new HintMessageAsset("Is " + pissy + " the character you want to play as? If so, press Y. Otherwise, press N.", 24, ClientPrefs.smallScreenFix);
        add(hint);
        add(hint.ADD_ME);
        preview = new Boyfriend(150, 300, pissy);
        preview.screenCenter();
        add(preview);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (preview != null) {
            preview.update(elapsed);
            if (preview.animation.curAnim.finished && preview.animation.curAnim.name != poopy) {
                preview.dance();
            }
        }

        if (FlxG.keys.justPressed.Y) {
            preview.playAnim(poopy);
            SelectChara.bfOverride = pissy;
            FlxG.sound.play(Paths.sound("confirmMenu"), 1, false, null, true, function() {
                StageData.loadDirectory(PlayState.SONG);
                LoadingState.loadAndSwitchState(new PlayState());
            });
        }

        if (FlxG.keys.justPressed.N) {
            close();
        }
    }
}