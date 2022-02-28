package options;

import flixel.FlxG;
import DialogueBoxPsych;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import haxe.Json;
import Paths;
import flixel.util.FlxTimer;

using StringTools;

/**Snowdrift stuff. Has some settings I'm too lazy to add to other things.*/
class SnowdriftStuff extends BaseOptionsMenu {

    public function new() {
        if (bg != null) bg.color = 0xFFAACCFF;
        trace('give me beans');
        title = 'Snowdrift\'s Menu';
        rpcTitle = 'Visiting Snowdrift in Options Menu';
        var option:Option = new Option('Small Screen Fix', //Name
			'Press H to know more about this!', //Description
			'smallScreenFix', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);
        var option:Option = new Option('Preload certain states', //Name
			'Press H to know more about this!', //Description
			'preloadStates', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);
        var option:Option = new Option('Skip Character Select', //Name
			'Press H to know more about this!', //Description
			'skipCharaSelect', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);
        sdOption = 'smallScreenFix';
        inSnowdriftMenu = true;
        super();
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.H) {
            super.startDialogue(dumb);
        }

        if (psychDialogue != null) {
            psychDialogue.update(elapsed);
        }

        super.update(elapsed);
    }
}

/**funny intro thing idk*/
class SnowdriftIntro extends MusicBeatState {
    var bg:FlxSprite;
    var dumb:DialogueFile;
    var dialogueCount:Int = 0;
    var psychDialogue:DialogueBoxPsych;

    public function new() {
        super();
        FlxG.sound.playMusic(Paths.modsMusic('DaveDialogue'));
        bg = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.color = 0xFFAACCFF;
        add(bg);
        dumb = cast Json.parse(Paths.snowdriftChatter('firstIntro'));
    }
    override function update(elapsed:Float) {
        if (psychDialogue != null) {
            psychDialogue.update(elapsed);
        }
    }
    override function create() {
        new FlxTimer().start(3, function(tmr:FlxTimer) {
            startDialogue(dumb);
        });
    }
    public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
        {
            // TO DO: Make this more flexible, maybe?
            if(psychDialogue != null) return;
    
            if(dialogueFile.dialogue.length > 0) {
                // inCutscene = true;
                CoolUtil.precacheSound('dialogue');
                CoolUtil.precacheSound('dialogueClose');
                psychDialogue = new DialogueBoxPsych(dialogueFile);
                psychDialogue.scrollFactor.set();
                    psychDialogue.finishThing = function() {
                        psychDialogue = null;
                        FlxG.save.data.seenSnowdriftIntro = true;
                        MusicBeatState.switchState(new options.OptionsState());
                    }
                psychDialogue.nextDialogueThing = startNextDialogue;
                psychDialogue.skipDialogueThing = skipDialogue;
                // psychDialogue.cameras = [camHUD];
                add(psychDialogue);
            } else {
                FlxG.log.warn('Your dialogue file is badly formatted!');
                MusicBeatState.switchState(new options.OptionsState());
            }
        }
        //var dialogueCount:Int = 0;
        function startNextDialogue() {
            dialogueCount++;
        }

        function skipDialogue() {
            //callOnLuas('onSkipDialogue', [dialogueCount]);
            trace('ass');
        }
}