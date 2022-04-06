package randomShit;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Assets;

class FunkySprite extends Sprite {
    var shitInfo:openfl.geom.ColorTransform;
    var pissRandom:flixel.math.FlxRandom;
    var shitmap:Bitmap;
    public function new() {
        super();
        pissRandom = new flixel.math.FlxRandom();
        shitInfo = new openfl.geom.ColorTransform(1, 1, 1, 1, pissRandom.int(-255, 255), pissRandom.int(-255, 255), pissRandom.int(-255, 255), 0);
        var shitmapData = Assets.getBitmapData("assets/images/menuDesat.png");
        shitmapData.colorTransform(shitmapData.rect, shitInfo);
        shitmap = new Bitmap(shitmapData);
        addChild(shitmap);
    }

    public function resetColor() {
        shitInfo.blueOffset = pissRandom.int(-255, 255);
        shitInfo.greenOffset = pissRandom.int(-255, 255);
        shitInfo.redOffset = pissRandom.int(-255, 255);
        shitmap.transform.colorTransform = shitInfo;
    }
}