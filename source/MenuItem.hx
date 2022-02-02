package;

import haxe.ValueException;
import sys.FileSystem;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuItem extends FlxSprite
{
	public var targetY:Float = 0;
	public var flashingInt:Int = 0;
	var sussy:Bool = false;

	public function new(x:Float, y:Float, weekName:String = '')
	{
		super(x, y);
		if (FileSystem.exists(Paths.modsImages('storymenu/' + weekName))) {
			loadGraphic(Paths.modsImages('storymenu/' + weekName));
		}else if(FileSystem.exists(Paths.image('storymenu/' + weekName))) {
		loadGraphic(Paths.image('storymenu/' + weekName));
		} else if (FileSystem.exists('assets/images/storymenu/placeholder.png')) {
		 frames = FlxAtlasFrames.fromSparrow('assets/images/storymenu/placeholder.png', 'assets/images/storymenu/placeholder.xml');
		 setGraphicSize(128, 128);
		 updateHitbox();
		 animation.addByPrefix('placeholder', 'you CANNOT stop this', 30, true);
		 animation.addByPrefix('selected', 'you CANNOT stop this', 90, true);
		 animation.play('placeholder');
		} else {
			throw new ValueException("How could you get rid of the amogus placeholder? You can't use the story menu until you get that back, so I recommend either redownloading it from GitHub or just using the amogus placeholder.fla in the source");
		}
		//trace('Test added: ' + WeekData.getWeekNumber(weekNum) + ' (' + weekNum + ')');
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	private var isFlashing:Bool = false;

	public function startFlashing():Void
	{
		if (frames == Paths.getSparrowAtlas('storymenu/placeholder.png') && animation.getByName('selected') != null) {
			animation.play('selected');
			sussy = true;
		}
		isFlashing = true;
	}

	// if it runs at 60fps, fake framerate will be 6
	// if it runs at 144 fps, fake framerate will be like 14, and will update the graphic every 0.016666 * 3 seconds still???
	// so it runs basically every so many seconds, not dependant on framerate??
	// I'm still learning how math works thanks whoever is reading this lol
	var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		y = FlxMath.lerp(y, (targetY * 120) + 480, CoolUtil.boundTo(elapsed * 10.2, 0, 1));

		if (isFlashing)
			flashingInt += 1;

		/*if (sussy) {
			fakeFramerate = 300;
		}*/

		if (flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2))
			color = 0xFF33ffff;
		else
			color = FlxColor.WHITE;
	}
}
