package editors.soundtrack.colour;

import randomShit.dumb.SoundtrackMenu.SongColorInfo;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import randomShit.util.HintMessageAsset;
import flixel.util.FlxColor;
import randomShit.util.DumbUtil;
import editors.soundtrack.colour.MainColourSubstate;
import editors.soundtrack.colour.ColourPreviewSquare;
import randomShit.util.KeyboardUtil;
import randomShit.dumb.SoundtrackMenu.OSTData;
using StringTools;

/**This substate lets you change the RED value of the soundtrack bg color.
    @since March 2022 (Emo Engine 0.2.0)*/
class RedSubState extends MusicBeatSubstate {
    var curColor:SongColorInfo;
    var newColor:SongColorInfo;
    var previewSquare:ColourPreviewSquare;
    var bg:FlxSprite;
    var hint:HintMessageAsset;
    var redText:FlxText;
    public function new() {
        curColor = MainColourSubstate.newColor;
        newColor = curColor;
        super();
    }

    override function create() {
        bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, 0x42424242);
        add(bg);
        previewSquare = new ColourPreviewSquare(FlxColor.fromRGB(newColor.red, newColor.green, newColor.blue));
        add(previewSquare);
        redText = new FlxText(previewSquare.x, previewSquare.y - 69, 0, Std.string(newColor.red), 12);
        add(redText);
        hint = new HintMessageAsset("Press LEFT or RIGHT to adjust the red value. Press " + KeyboardUtil.getKeyNames(ClientPrefs.keyBinds["back"]) + " to save.", 24, ClientPrefs.smallScreenFix);
        add(hint);
        add(hint.ADD_ME);
    }

    override function update(elapsed:Float) {
        if (controls.UI_LEFT) {
            modifyColors(-1);
        }
        if (controls.UI_RIGHT) {
            modifyColors(1);
        }
        if (controls.BACK) {
            MainColourSubstate.newColor = newColor;
            close();
        }
        super.update(elapsed);
    }

    function modifyColors(change:Int = 0) {
        var redColor = newColor.red;
        var curGreen = newColor.green;
        var curBlue = newColor.blue;
        redColor += change;
        if (redColor >= 255) {
            redColor = 255;
        }
        if (redColor <= 0) {
            redColor = 0;
        }
        newColor.red = redColor;
        previewSquare.updateFromSCI(newColor);
    }
}