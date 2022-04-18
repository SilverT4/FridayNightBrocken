package;

import flixel.tweens.FlxTween;
import randomShit.util.SussyUtilities;
import flixel.util.FlxTimer;
import ProfileThingy.PrelaunchProfileState;
import flixel.FlxG;
import flixel.FlxState;
import TitleState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import characters.Snowdrift;

using StringTools;

/**This state will disable certain functionality that may trigger your PC's antivirus.
@since March 2022 (Emo Engine v0.1.2)*/
class AntivirusAvoidanceState extends FlxState {
    var yesButton:FlxButton;
    var noButton:FlxButton;
    var messageText:FlxText;
    var bg:FlxSprite;
    var nextButtonOne:FlxButton;
    var nextButtonTwo:FlxButton;
    var finishButton:FlxButton;
    var funnySnowman:Snowdrift;
    public static var DISABLE_SUS_FUNC:Bool = false;
    public function new() {
        super();
        if (!FlxG.mouse.visible) FlxG.mouse.visible = true;
    }

    override function create() {
        if (FlxG.sound.music == null) {
            FlxG.sound.playMusic(Paths.music('wiiPlay_Title'), 0);
            FlxG.sound.music.fadeIn(0.5, 0, 0.7);
        }
        bg = new FlxSprite(0);
        bg.loadGraphic(Paths.image('menuDesat'));
        bg.color = 0xFF00007F;
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.screenCenter();
        add(bg);

        #if debug
        var shitpost:Map<String, Dynamic> = new Map();
        FlxG.save.data.BussyMap = shitpost;
        var piss = new flixel.system.FlxSound().loadEmbedded(Paths.inst('splitathon'));
        FlxG.save.data.BussyMap.set("funny?", piss);
        #end

        messageText = new FlxText(0, 0, 0, "Hey there!\n\nI've got an important question for you.", 24);
        messageText.setFormat(null, 24, FlxColor.WHITE, CENTER);
        messageText.screenCenter();
        messageText.scrollFactor.set();
        add(messageText);

        nextButtonOne = new FlxButton(850, 600, 'Next', showAVExplan);
        add(nextButtonOne);

        nextButtonTwo = new FlxButton(850, 600, 'Next', askPreference);
        add(nextButtonTwo);
        nextButtonTwo.kill();

        yesButton = new FlxButton(400, 600, 'Yes', disableFunctions);
        yesButton.color = 0xFF007F00;
        yesButton.label.color = 0xFFFFFFFF;
        add(yesButton);
        yesButton.kill();

        noButton = new FlxButton(800, 600, 'No', keepFunctions);
        noButton.color = 0xFFFF0000;
        noButton.label.color = 0xFFFFFFFF;
        add(noButton);
        noButton.kill();

        finishButton = new FlxButton(600, 600, "Let's play!", function() {
            FlxG.sound.play(Paths.sound('confirmMenu'), 1, false, null, true, function() {
                FlxG.cameras.fade(FlxColor.BLACK, 1, false, function() {
                    FlxG.sound.music.fadeOut(0.5, 0, function(twn:flixel.tweens.FlxTween) {
                        FlxG.sound.music.stop();
                        FlxG.sound.music = null;
                        FlxG.switchState(new TestProfileState());
                    });
                });
            });
        });
        add(finishButton);
        finishButton.kill();
        funnySnowman = new Snowdrift(1014, 2431);
        funnySnowman.setGraphicSize((Std.int(funnySnowman.width * 0.7)));
        funnySnowman.switchAnim("awkward-idle");
        var BEST_SPOT:Dynamic = {
            x: 1014,
            y: 431
        };
        FlxTween.tween(funnySnowman, BEST_SPOT, 0.5);
        add(funnySnowman);
    }

    function showAVExplan() {
        trace('explaining!');
        messageText.text = "So. Stupidity Engine, as this fork of Psych Engine is called,\nhas a few functions in it that may\ntrigger your computer's antivirus. I imagine you wouldn't\nwant to be playing the game and then it suddenly gets closed\nbecause of your antivirus blocking the program...";
        messageText.fieldWidth = 0;
        messageText.screenCenter();
        nextButtonOne.kill();
        nextButtonTwo.revive();
        funnySnowman.switchAnim("filestuff-idle");
    }

    function askPreference() {
        trace('bitches?');
        messageText.text = "Now, with that in mind...\n\nI can disable these functions for you. As far as I'm aware, the\nfunctions are pretty much unused anyways, so\nyour gameplay shouldn't REALLY be affected by\ndisabling them. Unfortunately, I don't know how to\nSAVE your preference, so I'll have to ask your preference\nevery time you start. Anyway, would\nyou like me to disable these functions?";
        messageText.fieldWidth = 0;
        messageText.screenCenter();
        nextButtonTwo.kill();
        FlxG.sound.play(Paths.sound('warning'), 1, false, null, true, function() {
            yesButton.revive();
            noButton.revive();
        });
        funnySnowman.switchAnim("talk-idle");
    }

    function keepFunctions() {
        trace('keeping!');
        messageText.text = "Ok! I'll keep them enabled.\nNow then, let's get you into the game.\n\nHave fun!";
        messageText.fieldWidth = 0;
        messageText.screenCenter();
        noButton.kill();
        yesButton.kill();
        funnySnowman.switchAnim("excited-idle");
        FlxG.sound.play(Paths.sound('balance-Great'), 1, false, null, true, function() {
            finishButton.revive();
        });
    }

    function disableFunctions() {
        trace('disabling!');
        messageText.text = "Alright, cool. I'll disable those for you. Give me just a second...";
        messageText.fieldWidth = 0;
        messageText.screenCenter();
        funnySnowman.switchAnim("sus-idle");
        noButton.kill();
        yesButton.kill();
        new FlxTimer().start(3, function(tmr:FlxTimer) {
            messageText.text = "You're all set! Now then, let's get you into the game.\n\nHave fun, buddy!";
            messageText.fieldWidth = 0;
            messageText.screenCenter();
            funnySnowman.switchAnim("excited-idle");
            FlxG.sound.play(Paths.sound('balance-Done'), 1, false, null, true, function() {
                DISABLE_SUS_FUNC = true;
                SussyUtilities.FUNCTIONS_CEASED = true;
                finishButton.revive();
            });
        });
    }

    override function update(elapsed:Float) {
        //not keeping this
        super.update(elapsed);
        if (FlxG.keys.justPressed.SEVEN) {
            FlxG.switchState(new MusicBeatLauncher(new randomShit.dumb.SoundtrackMenu()));
        }
        /*#if debug
        if (funnySnowman != null) {
            funnySnowman.setPosition(FlxG.mouse.x, FlxG.mouse.y);
            funnySnowman.update(elapsed);
            if (FlxG.keys.justPressed.W) {
                funnySnowman.DEBUG_CH_ANIM_KEY(-1);
            }
            if (FlxG.keys.justPressed.S) {
                funnySnowman.DEBUG_CH_ANIM_KEY(1);
            }
            if (FlxG.keys.justPressed.UP) {
                switchTheSnowmanSize(0.1);
            }
            if (FlxG.keys.justPressed.DOWN) {
                switchTheSnowmanSize(-0.1);
            }
            if (FlxG.mouse.justPressed) {
                trace(funnySnowman);
                FlxG.log.add(funnySnowman);
            }
        }
        #end */
    }

    #if debug
    var curScale:Float = 1;
    function switchTheSnowmanSize(Change:Float) {
        curScale += Change;
        funnySnowman.setGraphicSize(Std.int(funnySnowman.width * curScale));
        trace(curScale);
    }
    #end
}