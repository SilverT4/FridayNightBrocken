package randomShit.util;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import Paths;
import flixel.util.FlxColor;

using StringTools;

class HintMessageAsset extends FlxSprite {
    @:noCompletion @:noPrivateAccess var txt:HintMessageText;
    static inline final MESSAGE_HINT_COLOUR:FlxColor = 0x69000000;
    public var ADD_ME:HintMessageText;
    public function new (message:String, msgFontSize:Int, onSmallScreen:Bool) {
        if (onSmallScreen) {
            trace('smol');
            super(0, 0);
            makeGraphic(FlxG.width, msgFontSize + 4, MESSAGE_HINT_COLOUR);
        } else {
            trace('I LOVE LEAN!!!!!!');
            super(0, FlxG.height - (msgFontSize + 4));
            makeGraphic(FlxG.width, msgFontSize + 4, MESSAGE_HINT_COLOUR);
        }

        txt = new HintMessageText(0, this.y + 2, message, msgFontSize);
        ADD_ME = txt;
    }

    public function setText(newText:String) {
        txt.text = newText;
        txt.fieldWidth = 0;
    }
}

class HintMessageText extends FlxText {
    public function new (x:Float, y:Float, message:String, fontSize:Int) {
        super(x, y, 0, message, 24);
        setFormat("VCR OSD Mono", fontSize, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        scrollFactor.set();
    }
}