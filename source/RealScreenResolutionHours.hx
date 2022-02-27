package;

import flixel.util.FlxColor;
import haxe.Json;
import flixel.FlxSprite;
import DialogueBoxPsych;
import flixel.FlxG;
import openfl.system.Capabilities;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import HealthIcon as SnowdriftIcon;
import Paths;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;
/**This is a typedef ONLY used here.*/
typedef YourScreen = {
    var scWidth:Float;
    var scHeight:Float;
}
/* hENLO it is nearly 1am as i commit this, im tired and will work on this tmr*/
class RealScreenResolutionHours extends MusicBeatState {
    var yesThisExists:SnowdriftIcon;
    var windowsScreen:FlxSprite;
    var grabbed:YourScreen;
    var grabbedString:String;
    var psychDialogue:DialogueBoxPsych;
    var curDialogue:DialogueFile;
    var exitingMenu:Bool = false;
    var seenExplanation:Bool = false;
    var currentStep:Int = 0;
    public static var seenMessage:Bool = false;
    public static var screenShoe:Array<Float> = [];
    var resolutionMessage:String;

    public function new() {
        super();
        FlxG.mouse.useSystemCursor = true;
        if (!FlxG.mouse.visible) FlxG.mouse.visible = true;
        var back:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        back.setGraphicSize(Std.int(back.width * 1.1));
        back.color = 0xFFAACCFF;
        back.scrollFactor.set();
        add(back);
        grabbed.scWidth = Capabilities.screenResolutionX;
        grabbed.scHeight = Capabilities.screenResolutionY;
        grabbedString = grabbed.scWidth + 'x' + grabbed.scHeight;
        trace(grabbedString);
        resolutionMessage = '{
            "dialogue": [
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "excited",
                    "text": "Hi there!"
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "awkward",
                    "text": "So... This may be a bit awkward."
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "awkward",
                    "text": "Your screen resolution appears to be $grabbedString."
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "awkward",
                    "text": "Now, the first number there isn\'t REALLY an issue..."
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "awkward",
                    "text": "It\'s the second one that is."
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "talk",
                    "text": "Now, one thing to note is that Friday Night Funkin, at least on Windows,"
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "talk",
                    "text": "runs at a resolution of 1280x720. On a screen with a HEIGHT like yours, some game elements"
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "talk",
                    "text": "may end up hidden behind your taskbar, like in the screenshot I\'ll show you in a second."
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "awkward",
                    "text": "However, I DO have something that may be useful for you."
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "talk",
                    "text": "I can show you how to move your taskbar on Windows 10 if you use the latest version, which would probably work, OR..."
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "excited",
                    "text": "I can set the elements that may end up hidden behind your taskbar so they\'re at the top of your screen instead, which would allow"
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "excited",
                    "text": "you to see them without having to adjust any settings on your computer."
                },
                {
                    "speed": 0.035,
                    "portrait": "snowdrift",
                    "boxState": "normal",
                    "expression": "talk",
                    "text": "Now then... What do you want to do?"
                }
            ]
        }
        ';
        curDialogue = cast Json.parse(resolutionMessage);
    }
    override function create() {
        if (!FlxG.sound.music.playing) {
            FlxG.sound.playMusic(Paths.music('desktop'));
        }
        currentStep = 1;
        startDialogue(curDialogue);
    }
    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.PERIOD) {
            MusicBeatState.switchState(new MainMenuState());
        }
        if (windowsThing != null) {
            windowsThing.update(elapsed);
        }
        if (explanText != null) {
            explanText.update(elapsed);
            if (explanText.text != explanTexts[cum]) explanText.text = explanTexts[cum];
        }
        if (inExplanation) {
            if (FlxG.keys.justPressed.ENTER) {
                FlxG.sound.play(Paths.sound('menuScroll'));
                if (cum <= explanTexts.length) cum++;
            }
        }
    }
    function showOptions() {
        trace('prevent compile fail');
        if (!seenExplanation) {
            currentStep = 2;
        } else {
            currentStep = 5;
        }
    }

    function doStepThings(step:Int) {
        switch(step) {
            case 0:
                trace('bg set');
            case 1:
                trace('amogus');
                showScreenshot();
            case 2:
                generateOptionsInitial();
            case 3:
                #if windows
                explainTaskbarMovement();
                #elseif linux
                openSubState(new LinuxSmallScreen());
                #end
            case 4:
                setResolutionTrick();
            case 5:
                generateOptionsFinal();
        }
    }
    function exitScreen() {
        trace('done');
        MusicBeatState.switchState(new MainMenuState());
    }
    var desktopScreenshot:FlxSprite;
    function showScreenshot() {
        trace('fail prevention');
    }
    function setResolutionTrick() {
        trace('i need to set the resolution thing up elsewhere first');
    }
    /**generates the initial option menu*/
    function generateOptionsInitial() {
        trace('a');
    }
    /**if player hasn't set the trick from here then give option to set or exit*/
    function generateOptionsFinal() {
        trace('a');
    }
    var windowsThing:FlxSprite;
    var explanTexts:Array<String> = ["Alright, so. First things first... Click on the Action Centre icon. It'll be on your taskbar, right next to the clock.", "Now, click All settings.\n(If necessary, click Expand first)", "Once the Settings window opens, click Personalisation.", "On the left, click on Taskbar. If your window is too small, click the 3-line (menu) icon and click Taskbar.", "Where it says Taskbar location on screen, change the value to Top, Left, or Bottom.", "You can also enable the small taskbar buttons, which would give you more screen space.", "Or, you can enable auto-hide of the taskbar in desktop mode, which will bypass the need to move the taskbar at all.", "If you go for this, you can make the option appear again by hovering near the edge where your taskbar is."];
    var inExplanation:Bool = false;
    var explanText:FlxText;
    var cum:Int = 0;
    function explainTaskbarMovement() {
        trace('gonna get screenshots');
        windowsThing = new FlxSprite(0);
        windowsThing.frames = Paths.getSparrowAtlas(Paths.image('/windTaskShit'));
        windowsThing.animation.addByPrefix('init', 'desktop', 0);
        windowsThing.animation.addByPrefix('act', 'action', 0);
        windowsThing.animation.addByPrefix('settingsMain', 'setMain', 0);
        windowsThing.animation.addByPrefix('personalMain', 'setPersMain', 0);
        windowsThing.animation.addByPrefix('persTaskbar', 'setPersTask', 0);
        windowsThing.animation.play('init');
        windowsThing.setGraphicSize(Std.int(windowsThing.width * 0.87)); //WAS THAT THE WIDTH OF 87?! (i'm so sorry)
        windowsThing.updateHitbox();
        windowsThing.screenCenter(X);
        add(windowsThing);
        explanText = new FlxText(0, FlxG.height - 66, FlxG.width - 150, explanTexts[cum], 24);
        explanText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(explanText);
        yesThisExists = new SnowdriftIcon('snowcon');
        yesThisExists.x = FlxG.width - 150;
        yesThisExists.y = FlxG.height - 150;
        add(yesThisExists);
    }
    public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
        {
            // TO DO: Make this more flexible, maybe?
            if(psychDialogue != null) return;
    
            if(dialogueFile.dialogue.length > 0) {
                // inCutscene = true;
                CoolUtil.precacheSound('dialogue');
                CoolUtil.precacheSound('dialogueClose');
                psychDialogue = new DialogueBoxPsych(dialogueFile, song);
                psychDialogue.scrollFactor.set();
                if(exitingMenu) {
                    psychDialogue.finishThing = function() {
                        psychDialogue = null;
                        exitScreen();
                    }
                } else {
                    psychDialogue.finishThing = function() {
                        psychDialogue = null;
                        doStepThings(currentStep);
                    }
                }
                // psychDialogue.nextDialogueThing = startNextDialogue;
                // psychDialogue.skipDialogueThing = skipDialogue;
                // psychDialogue.cameras = [camHUD];
                add(psychDialogue);
            } else {
                FlxG.log.warn('Your dialogue file is badly formatted!');
                if(exitingMenu) {
                    exitScreen();
                } else {
                    showOptions();
                }
            }
        }
}