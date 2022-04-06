package flixel.system.ui;

import flash.display.Graphics;
import flash.display.Sprite;
import flixel.FlxG;
import randomShit.dumb.FunkyBackground;
import randomShit.util.HintMessageAsset;
import flixel.system.FlxAssets;
import openfl.system.Capabilities;
import randomShit.FunkySprite;
/**
    This class replaces the built-in FlxFocusLostScreen. It *SHOULD* perform the same function as [FocusLostScreen](FNF-PsychEngine/source/FocusLostScreen.hx), but I have yet to test it.
        @since April 2022 (Emo Engine 0.2.0)*/
class FunkyFocusLostScreen extends flixel.system.ui.FlxFocusLostScreen
{
    var peen:FunkyBackground;
    var Msg:HintMessageAsset;
	var sex:FunkySprite;
	public var timeSinceLastDraw:Int = 0;
	@:keep
	public function new()
	{
		super();
		draw();

        sex = new FunkySprite();
        addChild(sex);
		sex.resetColor();
        Msg = new HintMessageAsset("Your game has been paused due to not being the current active window. Switch back to this window to resume.", 24, Capabilities.screenResolutionY <= 768);
        var penis:Sprite = new Sprite();
        penis.graphics.beginBitmapFill(Msg.graphic.bitmap);
        addChild(penis);
        if (ClientPrefs.focusLoseSound != null) {
            FlxG.sound.play(Paths.soundRandom(ClientPrefs.focusLostSounds[ClientPrefs.focusLoseSound], 1, 3, (ClientPrefs.focusLoseSound == "FNF Original" || ClientPrefs.focusLoseSound == "Jiafei Scream") ? "shared" : null));
        }
		var logo:Sprite = new Sprite();
		FlxAssets.drawLogo(logo.graphics);
		logo.scaleX = logo.scaleY = 0.2;
		logo.x = logo.y = 5;
		logo.alpha = 0.35;
		addChild(logo);

		visible = false;
	}

	override function draw() {
		super.draw();
		if (sex != null && timeSinceLastDraw == 0) {
			sex.resetColor();
			timeSinceLastDraw = 1;
		} 
	}
}
