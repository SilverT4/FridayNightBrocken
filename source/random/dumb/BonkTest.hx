package random.dumb;

import flixel.FlxCamera;
import flixel.addons.ui.FlxUIInputText;
import Boyfriend;
import Character;
import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUIRadioGroup;
import flixel.addons.ui.FlxUI;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import random.dumb.Bonk;
import MusicBeatState;
import ClientPrefs;

using StringTools;

/**i wanna test bonk from options*/
class BonkTest extends MusicBeatState {
    var Bitch:Boyfriend;
    var BitchTwo:Character; // JUST SO THERE'S A FUCKIN THING FOR CHOICES
    var CharSelectUI:FlxUITabMenu;
    var CharSelectUI_Assets:FlxUI;
    var CharTypeThingy:FlxUIRadioGroup;
    var BonkButton:FlxButton;
    var daNut:Coconut;
    var hintText_Bg:FlxSprite;
    var hintText:FlxText;
    var bg:FlxSprite;
    var bonkCam:FlxCamera;
    var eGirl:FlxTimerManager;
    final DEFAULT_CHAR:String = 'bf';
    public static var instance:BonkTest;
    var curState = 'Selecting';

    public function new() {
        super();

        FlxG.mouse.visible = true;
    }

    override function create() {
        instance = this;
        eGirl = new FlxTimerManager();
        bg = new FlxSprite();
        bg.loadGraphic(Paths.image('menuDesat'));
        bg.color = 0xFF343411;
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.screenCenter();
        add(bg);
        daNut = new Coconut(0, -500, 'TEST_BF');
        add(daNut);
        var tabs = [
            { name: 'Character', label: 'Character' }
        ];
        bonkCam = new FlxCamera();
        bonkCam.bgColor.alpha = 0;
        FlxG.cameras.add(bonkCam);
        daNut.cameras = [bonkCam];
        CharSelectUI = new FlxUITabMenu(null, tabs);
        CharSelectUI.resize(250, 200);
        CharSelectUI.screenCenter();
        createCharSelUI();
        add(CharSelectUI);
        hintText_Bg = new FlxSprite();
        hintText_Bg.makeGraphic(FlxG.width, 26, FlxColor.fromRGB(0, 0, 0, 128));
        if (ClientPrefs.smallScreenFix) trace('0 is fine!') else hintText_Bg.y = FlxG.height - 26;
        add(hintText_Bg);
        hintText = new FlxText(0, hintText_Bg.y + 4, FlxG.width, 'Select a character and its type, then click OK!', 24);
        hintText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(hintText);
    }
    var CharTypes:Array<String> = ['bf', 'gf', 'dad'];
    var CharLabels:Array<String> = ['Boyfriend', 'Girlfriend', 'Opponent'];
    var characterType:String = 'bf';
    var CharInput:FlxUIInputText;
    function createCharSelUI() {
        CharSelectUI_Assets = new FlxUI(null, CharSelectUI);
        CharSelectUI_Assets.name = 'Character';
        CharInput = new FlxUIInputText(10, 20, 200, 'bf', 8);

        CharTypeThingy = new FlxUIRadioGroup(10, CharInput.y + 30, CharTypes, CharLabels, setCharaType);

        var okButton:FlxButton = new FlxButton(120, 200, 'OK', positionChar);

        CharSelectUI_Assets.add(new FlxText(CharInput.x, CharInput.y - 18, 'Character name', 8));
        CharSelectUI_Assets.add(CharInput);
        CharSelectUI_Assets.add(CharTypeThingy);
        CharSelectUI_Assets.add(okButton);
        CharSelectUI.addGroup(CharSelectUI_Assets);
    }

    function setCharaType(Char:String):Void {
        characterType = Char;
    }
    var daTarget:Dynamic;
    function positionChar() {
        if (CharInput != null) {
            switch (characterType) {
                case 'bf':
                    Bitch = new Boyfriend(0, 0, CharInput.text);
                    daTarget = Bitch;
                    add(Bitch);
                case 'gf' | 'dad':
                    BitchTwo = new Character(0, 0, CharInput.text);
                    daTarget = BitchTwo;
                    add(BitchTwo);
            }
            CharSelectUI.kill(); // SO WE CAN REVIVE IT!
            curState = 'Positioning';
            hintText.text = 'Use your mouse to position your character. Click to set that position.';
        } else {
            throw new haxe.Exception('suss mogus');
        }
    }

    override function update(elapsed:Float) {
        if (Bitch != null && (curState == 'Positioning' || curState == 'Previewing')) {
            if (curState == 'Positioning') {
                Bitch.x = FlxG.mouse.x;
                Bitch.y = FlxG.mouse.y;
            }
            Bitch.update(elapsed);
            if (Bitch.animation.curAnim.finished && !Bitch.specialAnim) {
                Bitch.dance();
            }
        }
        if (BitchTwo != null && (curState == 'Positioning' || curState == 'Previewing')) {
            if (curState == 'Positioning') {
                BitchTwo.x = FlxG.mouse.x;
                BitchTwo.y = FlxG.mouse.y;
            }
            BitchTwo.update(elapsed);
            if (BitchTwo.animation.curAnim.finished && !BitchTwo.specialAnim) {
                BitchTwo.dance();
            }
        }

        switch (curState) {
            case 'Positioning':
                if (FlxG.mouse.justPressed) {
                    curState = 'Previewing';
                    if (BonkButton == null) addBonkButton() else showBonkButton();
                }
                if (controls.BACK) {
                    curState = 'Selecting';
                    if (CharSelectUI != null) CharSelectUI.revive();
                }
            case 'Previewing':
                if (controls.BACK) {
                    curState = 'Positioning';
                    hideBonkButton();
                    hintText.text = 'Use your mouse to position the character. Click to set that as your location.';
                }
            case 'Selecting':
                if (Bitch != null) {
                    Bitch.destroy();
                    Bitch = null;
                }
                if (BitchTwo != null) {
                    BitchTwo.destroy();
                    BitchTwo = null;
                }
                if (controls.BACK && !CharInput.hasFocus) {
                    eGirl.clear();
                    MusicBeatState.switchState(new options.OptionsStateExtra());
                }
        }

        if (CharInput.hasFocus) {
            FlxG.sound.muteKeys = null;
		    FlxG.sound.volumeDownKeys = null;
		    FlxG.sound.volumeUpKeys = null;
        } else {
            FlxG.sound.muteKeys = TitleState.muteKeys;
		    FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		    FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
        }

        super.update(elapsed);
    }

    function addBonkButton() {
        BonkButton = new FlxButton(0, hintText_Bg.y - 20, 'BONK!', doTheFunny);
        if (ClientPrefs.smallScreenFix) BonkButton.y += 40;
        BonkButton.screenCenter(X);
        add(BonkButton);
        hintText.text = 'Click BONK! to bonk!';
    }

    function hideBonkButton() {
        BonkButton.kill();
    }

    function showBonkButton() {
        BonkButton.revive();
    }

    function doTheFunny() {
        daNut.x = daTarget.getGraphicMidpoint().x;
        daNut.y = daTarget.getGraphicMidpoint().y - 1000;
        daNut.alpha = 1;
        daNut.visible = true;
        daNut.fall();
    }
    var colourThing:FlxTween;
    public function doFunnyStuff() {
        if (Bitch != null) {
            Bitch.color = 0xFFFF0000;
            colourThing = FlxTween.tween(Bitch, { "color": FlxColor.WHITE }, 1.5, { onComplete: function (twn:FlxTween) {
                trace('penis');
            }});
            trace(Bitch.animOffsets);
            if (Bitch.animation.getByName('hurt') != null) {
                Bitch.playAnim('hurt');
            } else if (Bitch.animation.getByName('scared') != null) {
                Bitch.playAnim('scared');
            } else if (Bitch.animation.getByName('sad') != null) {
                Bitch.playAnim('sad');
            } else {
                Bitch.playAnim('singDOWN');
            }
            Bitch.specialAnim = true;
            new FlxTimer().start(3, function(tmr:FlxTimer) {
                if (Bitch != null) {
                    Bitch.specialAnim = false;
                    Bitch.dance();
                }
            });
            daNut.resetCoconut();
        } else if (BitchTwo != null) {
            BitchTwo.color = 0xFFFF0000;
            colourThing = FlxTween.tween(BitchTwo, { "color": FlxColor.WHITE }, 1.5, { onComplete: function (twn:FlxTween) {
                trace('penis');
            }});
            trace(BitchTwo.animOffsets);
            if (BitchTwo.animation.getByName('hurt') != null) {
                BitchTwo.playAnim('hurt');
            } else if (BitchTwo.animation.getByName('scared') != null) {
                BitchTwo.playAnim('scared');
            } else if (BitchTwo.animation.getByName('sad') != null) {
                BitchTwo.playAnim('sad');
            } else {
                BitchTwo.playAnim('singDOWN');
            }
            BitchTwo.specialAnim = true;
            new FlxTimer().start(3, function(tmr:FlxTimer) {
                if (BitchTwo != null) {
                    BitchTwo.specialAnim = false;
                    BitchTwo.dance();
                }
            });
            daNut.resetCoconut();
        }
    }
}
