package options.charas;

import flixel.math.FlxMath;
import flixel.addons.ui.FlxUIInputText;
import Character;
import flixel.FlxG;
import flixel.FlxSprite;
import randomShit.dumb.FunkyBackground;
import Paths;
import flixel.util.FlxColor;
import randomShit.util.DumbUtil;
import randomShit.util.HintMessageAsset;
import randomShit.util.KeyboardUtil;
import FlxUIDropDownMenuCustom;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.FlxObject;

using StringTools;

/**Character test state. Has a dropdown to set the animation played when you press SPACE
    
@since March 2022 (Emo Engine 0.1.2)*/
class CharacterTester extends MusicBeatState {
    var daChar:Character;
    var daAnims:Array<AnimArray>;
    var daName:String = '';
    var hint:HintMessageAsset;
    var useAlt:Bool = false;
    var SPACE_ANIM:String = 'hey';
    var spaceAnimDropDown:FlxUIDropDownMenuCustom;
    var bg:FunkyBackground;
    var hintCam:FlxCamera;
    var SHIT = '';

    public function new(CharacterName:String) {
        super();
        daName = CharacterName;
        FlxG.mouse.visible = true;
    }

    var animating:Bool = false;
    var camFollow:FlxPoint;
    var camFollowPos:FlxObject;
    var cumCam:FlxCamera;
    override function create() {
        cumCam = new FlxCamera();
        cumCam.bgColor.alpha = 0;
        hintCam = new FlxCamera();
        hintCam.bgColor.alpha = 0;
        FlxG.cameras.add(cumCam, true);
        FlxG.cameras.add(hintCam);
        daChar = new Character(400, 150, daName);
        bg = new FunkyBackground().setColor(DumbUtil.getFromRGB(daChar.healthColorArray), false);
        bg.scrollFactor.set();
        add(bg);
        daChar.x += daChar.positionArray[0];
        daChar.y += daChar.positionArray[1];
        daAnims = daChar.animationsArray;
        add(daChar);
        SHIT = "Use your keys to control the character and make them sing. Press " + KeyboardUtil.getKeyNames(ClientPrefs.keyBinds["back"]) + " to exit | Using alt anims: " + useAlt;
        hint = new HintMessageAsset(SHIT, 24, ClientPrefs.smallScreenFix);
        hint.cameras = [hintCam];
        hint.ADD_ME.cameras = [hintCam];
        add(hint);
        add(hint.ADD_ME);
        spaceAnimDropDown = new FlxUIDropDownMenuCustom(0, hint.y - 26, FlxUIDropDownMenuCustom.makeStrIdLabelArray(getAnimNames(), true), function(ena:String) {
            SPACE_ANIM = daAnims[Std.parseInt(ena)].anim;
        });
        spaceAnimDropDown.selectedLabel = SPACE_ANIM;
        spaceAnimDropDown.cameras = [hintCam];
        add(spaceAnimDropDown);
        camFollow = new FlxPoint(daChar.getGraphicMidpoint().x, daChar.getGraphicMidpoint().y);
        camFollowPos = new FlxObject(0, 0, 1, 1);
        camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
        add(camFollowPos);
        cumCam.follow(camFollowPos, LOCKON, 1);
        fixCamPos = true;
        isFollowingNow = true;
    }

    function getAnimNames() {
        var eee:Array<String> = [];
        for (anim in daAnims) {
            if (!anim.anim.contains('sing') && !anim.anim.contains('idle')) {
                eee.push(anim.anim); // I DONT INCLUDE SING AND IDLE!
            }
        }
        return eee;
    }
    var blockingInput:Bool = false;
    var fixCamPos:Bool = false;
    var isFollowingNow:Bool = false;
    override function update(elapsed:Float) {
        if (!blockingInput) {
            if (controls.NOTE_LEFT) {
                doLeftAnim();
            }
            if (controls.NOTE_RIGHT) {
                doRightAnim();
            }
            if (controls.NOTE_DOWN) {
                doDownAnim();
            }
            if (controls.NOTE_UP) {
                doUpAnim();
            }
            if (FlxG.keys.justPressed.NINE) {
                toggleAlts();
            }
            if (FlxG.keys.justPressed.SPACE) {
                doSpaceAnim();
            }
            if (controls.NOTE_LEFT_R || controls.NOTE_UP_R || controls.NOTE_DOWN_R || controls.NOTE_RIGHT_R) {
                animating = false;
            }
            if (FlxG.sound.muteKeys == null) {
                FlxG.sound.muteKeys = TitleState.muteKeys;
            }
            if (FlxG.sound.volumeUpKeys == null) {
                FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
            }
            if (FlxG.sound.volumeDownKeys == null) {
                FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
            }
        }

        if (fixCamPos) {
            var lerpVal:Float = CoolUtil.boundTo(elapsed * 0.6, 0, 1);
            camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
        }

        if (blockingInput) {
            FlxG.sound.muteKeys = null;
            FlxG.sound.volumeUpKeys = null;
            FlxG.sound.volumeDownKeys = null;
        }

        if (daChar != null) {
            daChar.update(elapsed);
            if (!animating) daChar.dance();
            if (daChar.animation.curAnim.name == SPACE_ANIM && daChar.animation.curAnim.finished) animating = false;
        }

        if (spaceAnimDropDown != null) {
            if (spaceAnimDropDown.dropPanel.visible) {
                blockingInput = true;
            } else {
                blockingInput = false;
            }
        }

        super.update(elapsed);
    }
    function toggleAlts() {
        useAlt = !useAlt;
        SHIT = "Use your keys to control the character and make them sing. Press " + KeyboardUtil.getKeyNames(ClientPrefs.keyBinds["back"]) + " to exit | Using alt anims: " + useAlt;
        hint.setText(SHIT);
    }
    function doLeftAnim() {
        animating = true;
        if (useAlt) {
            daChar.playAnim('singLEFT-alt');
        } else {
            daChar.playAnim('singLEFT');
        }
    }
    function doRightAnim() {
        animating = true;
        if (useAlt) {
            daChar.playAnim('singRIGHT-alt');
        } else {
            daChar.playAnim('singRIGHT');
        }
    }
    function doDownAnim() {
        animating = true;
        if (useAlt) {
            daChar.playAnim('singDOWN-alt');
        } else {
            daChar.playAnim('singDOWN');
        }
    }
    function doUpAnim() {
        animating = true;
        if (useAlt) {
            daChar.playAnim('singUP-alt');
        } else {
            daChar.playAnim('singUP');
        }
    }
    function doSpaceAnim() {
        daChar.playAnim(SPACE_ANIM);
    }
}