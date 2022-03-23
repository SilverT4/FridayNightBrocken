package randomShit.dumb;

import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import DialogueBoxPsych;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import flash.net.FileFilter;
import haxe.Json;
import MusicBeatState;
import randomShit.util.CustomRandom;
#if sys
import sys.io.File;
#end

using StringTools;

/**This is meant to allow the user to preview dialogue they've created.
@since March 2022 (Emo Engine 0.1.1)*/
class DialogueTestingState extends MusicBeatState {
    var psychDialogue:DialogueBoxPsych;
    var dialogueCount:Int = 0;
    var browseMsg:FlxText;
    var bg:FlxSprite;
    var dialogueFile:DialogueFile;

    public function new() {
        super();
    }

    override function create() {
        bg = new FlxSprite();
        bg.loadGraphic(Paths.image('menuDesat'));
        bg.color = CustomRandom.colour(null, FlxColor.WHITE);
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.scrollFactor.set();
        bg.screenCenter();
        add(bg);
        browseMsg = new FlxText(0, 0, FlxG.width, 'Select a dialogue file to preview it!\n\nClick the Cancel button to exit.', 48);
        browseMsg.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        browseMsg.screenCenter();
        add(browseMsg);
        new FlxTimer().start(1.5, function(tmr:FlxTimer) {
            loadDialogue();
        });
    }
    var diaBrowse:FileReference;
    function loadDialogue() {
        browseMsg.kill();
        var jsonFilter = new FileFilter('Dialogue Json', 'json');
        diaBrowse = new FileReference();
        diaBrowse.addEventListener(Event.SELECT, onLoadComplete);
        diaBrowse.addEventListener(Event.CANCEL, onLoadCancel);
        diaBrowse.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
        diaBrowse.browse([jsonFilter]);
    }

    function onLoadComplete(_):Void {
        diaBrowse.removeEventListener(Event.SELECT, onLoadComplete);
        diaBrowse.removeEventListener(Event.CANCEL, onLoadCancel);
        diaBrowse.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);

        #if sys
        var fullPath:String = null;
		@:privateAccess
		if(diaBrowse.__path != null) fullPath = diaBrowse.__path;

		if(fullPath != null) {
			var rawJson:String = File.getContent(fullPath);
			if(rawJson != null) {
				var loadedDialog:DialogueFile = cast Json.parse(rawJson);
				if(loadedDialog.dialogue != null && loadedDialog.dialogue.length > 0) //Make sure it's really a dialogue file
				{
					var cutName:String = diaBrowse.name.substr(0, diaBrowse.name.length - 5);
					trace("Successfully loaded file: " + cutName);
					dialogueFile = loadedDialog;
					if (loadedDialog.dialogueMusic != null) {
						FlxG.sound.playMusic(loadedDialog.dialogueMusic);
                        FlxG.sound.music.fadeIn(1, 0, 0.8);
					}
					//changeText();
					diaBrowse = null;
                    startDialogue(dialogueFile);
					return;
				}
			}
		}
		diaBrowse = null;
		#else
		trace("File couldn't be loaded! You aren't on Desktop, are you?");
        performExitShit();
		#end
    }

    function onLoadCancel(_):Void {
        diaBrowse.removeEventListener(Event.SELECT, onLoadComplete);
        diaBrowse.removeEventListener(Event.CANCEL, onLoadCancel);
        diaBrowse.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);

        diaBrowse = null;
        performExitShit();
    }

    function onLoadError(_):Void {
        diaBrowse.removeEventListener(Event.SELECT, onLoadComplete);
        diaBrowse.removeEventListener(Event.CANCEL, onLoadCancel);
        diaBrowse.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
        diaBrowse = null;
        trace('something went wrong');
        performExitShit();
    }
    public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
        {
            // TO DO: Make this more flexible, maybe?
            if(psychDialogue != null) return;
    
            if(dialogueFile.dialogue.length > 0) {
                // inCutscene = true;
                CoolUtil.precacheSound('dialogue', 'shared');
                CoolUtil.precacheSound('dialogueClose', 'shared');
                psychDialogue = new DialogueBoxPsych(dialogueFile);
                psychDialogue.scrollFactor.set();
                    psychDialogue.finishThing = function() {
                        psychDialogue = null;
                        performExitShit();
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

        function performExitShit() {
            FlxG.sound.music.stop();
            MusicBeatState.switchState(new options.OptionsState());
        }
}