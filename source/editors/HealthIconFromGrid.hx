package editors;

import openfl.geom.Matrix;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import flixel.FlxCamera;
import MusicBeatSubstate;
import openfl.net.FileFilter;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.utils.ByteArray;
import lime.math.Rectangle;
import sys.io.FileOutput;
import sys.io.File;
import sys.FileSystem;
import randomShit.util.DevinsFileUtils;
using StringTools;
class HealthIconFromGrid extends MusicBeatSubstate {
	var iconGrid:FlxSprite;
	var bg:FlxSprite;
	var regIcon:FlxSprite;
	var regIconE:FlxSprite;
	var deaIcon:FlxSprite;
	var deaIconE:FlxSprite;
	var openButton:FlxButton;
	var doneButton:FlxButton;
	var bussyShart:FileReference;
	var farts:Array<FileFilter>;
	var pussy:FlxCamera;
	var iconManipulators:Array<FlxButton> = [];
	var susName:FlxUIInputText;
	var nameLABEL:FlxText;
	var dIconX:Int = 0;
	var dIconY:Int = 0;
	var rIconX:Int = 0;
	var rIconY:Int = 0;
	public var loadin:Bool = false;
	public static var instance:HealthIconFromGrid;


	public function new() {
		super();
		pussy = new FlxCamera();
		pussy.bgColor.alpha = 0;
		FlxG.cameras.add(pussy);
		bg = new FlxSprite(0).makeGraphic(1280, 720, FlxColor.fromRGB(127, 92, 31, 127));
		bg.screenCenter();
		bg.scrollFactor.set();
		bg.cameras = [pussy];
		add(bg);
		
		// im so confused by this
		iconGrid = new FlxSprite(0, 300);
		iconGrid.cameras = [pussy];
		add(iconGrid);
		farts = [];
		var shits = new FileFilter('Icon Grid image (.png)', '*.png', 'Image');
		farts.push(shits);
		openButton = new FlxButton(300, 15, 'Open grid...', function () {
			trace('NOTE: It is recommended to make sure your grid is named so you know which grid you are opening!');
			loadin = true;
			openGrid();
		});
		openButton.cameras = [pussy];
		add(openButton);
		doneButton = new FlxButton(600, 15, 'Done', function () {
			saveIconAndSet();
		});
		doneButton.cameras = [pussy];
		add(doneButton);
		regIcon = new FlxSprite(0, 4);
		regIcon.cameras = [pussy];
		regIconE = new FlxSprite();
		regIconE.loadGraphic('mods/images/icons/icon-bf.png', true, 150, 150);
		regIconE.animation.add('sus', [0], 0, false);
		regIconE.cameras = [pussy];
		add(regIconE);
		deaIconE = new FlxSprite();
		deaIconE.loadGraphic('mods/images/icons/icon-bf.png', true, 150, 150);
		deaIconE.animation.add('sus', [0], 0, false);
		deaIconE.cameras = [pussy];
		add(deaIconE);
		add(regIcon);
		deaIcon = new FlxSprite(150, 4);
		deaIcon.cameras = [pussy];
		add(deaIcon);
		susName = new FlxUIInputText(450, 15, 150, 'banana');
		susName.cameras = [pussy];
		nameLABEL = new FlxText(450, 0, FlxG.width, 'Icon name:', 8);
		nameLABEL.cameras = [pussy];
		add(susName);
		add(nameLABEL);
		makeManipButts();
	}
	function openGrid() {
		bussyShart = new FileReference();
		bussyShart.addEventListener(Event.SELECT, onLoadComplete);
		bussyShart.addEventListener(Event.CANCEL, onLoadCancel);
        bussyShart.addEventListener(IOErrorEvent.IO_ERROR, inWetVagina);
		bussyShart.browse(farts);
	}
	var curValueRI:Int = 0;
	var curValueDI:Int = 1;
	function makeManipButts() {
		var regIconLEFT:FlxButton = new FlxButton(0, 170, '<--', function () {
			curValueRI -= 1;
			trace('current reg icon: ' + curValueRI);
			if (curValueRI < 0) {
				curValueRI = 50;
			}
			if (curValueRI > 50) {
				curValueRI = 0;
			}
			switch (curValueRI) {
				case 0, 11, 21, 31, 41, 51:
					rIconX = 0;
				case 1, 12, 22, 32, 42, 52:
					rIconX = 150;
				case 2, 13, 23, 33, 43, 53:
					rIconX = 300;
				case 3, 14, 24, 34, 44, 54:
					rIconX = 450;
				case 4, 15, 25, 35, 45, 55:
					rIconX = 600;
				case 5, 16, 26, 36, 46, 56: 
					rIconX = 750;
				case 6, 17, 27, 37, 47, 57:
					rIconX = 900;
				case 7, 18, 28, 38, 48, 58:
					rIconX = 1050;
				case 8, 19, 29, 39, 49, 59:
					rIconX = 1200;
				case 10, 20, 30, 40, 50:
					rIconX = 1350;
			}
			switch (curValueRI) {
				case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10:
					rIconY = 0;
				case 11, 12, 13, 14, 15, 16, 17, 18, 19, 20:
					rIconY = 150;
				case 21, 22, 23, 24, 25, 26, 27, 28, 29, 30:
					rIconY = 300;
				case 31, 32, 33, 34, 35, 36, 37, 38, 39, 40:
					rIconY = 450;
				case 41, 42, 43, 44, 45, 46, 47, 48, 49, 50:
					rIconY = 600;
				case 51, 52, 53, 54, 55, 56, 57, 58, 59, 60: 
					rIconY = 750;
			}
			if (regIcon.animation.getByName('current') != null) {
				regIcon.animation.remove('current');
				regIcon.animation.play('default');
				regIcon.animation.add('current', [curValueRI], 0, false);
				regIcon.animation.play('current');
				regIconE.pixels.copyPixels(regIcon.framePixels, new openfl.geom.Rectangle(0, 0, regIconE.width, regIconE.height), new openfl.geom.Point(), null, null, true);
			} else {
				regIcon.animation.add('current', [curValueRI], 0, false);
				regIcon.animation.play('current');
				regIconE.pixels.copyPixels(regIcon.framePixels, new openfl.geom.Rectangle(0, 0, regIconE.width, regIconE.height), new openfl.geom.Point(), null, null, true);
			}
			trace(rIconX, rIconY);
		});
		var regIconRIGHT:FlxButton = new FlxButton(0, 190, '-->', function () {
			curValueRI += 1;
			trace('current reg icon: ' + curValueRI);
			if (curValueRI < 0) {
				curValueRI = 60;
			}
			if (curValueRI > 60) {
				curValueRI = 0;
			}
			switch (curValueRI) {
				case 0, 11, 21, 31, 41, 51:
					rIconX = 0;
				case 1, 12, 22, 32, 42, 52:
					rIconX = 150;
				case 2, 13, 23, 33, 43, 53:
					rIconX = 300;
				case 3, 14, 24, 34, 44, 54:
					rIconX = 450;
				case 4, 15, 25, 35, 45, 55:
					rIconX = 600;
				case 5, 16, 26, 36, 46, 56: 
					rIconX = 750;
				case 6, 17, 27, 37, 47, 57:
					rIconX = 900;
				case 7, 18, 28, 38, 48, 58:
					rIconX = 1050;
				case 8, 19, 29, 39, 49, 59:
					rIconX = 1200;
				case 10, 20, 30, 40, 50:
					rIconX = 1350;
			}
			switch (curValueRI) {
				case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10:
					rIconY = 0;
				case 11, 12, 13, 14, 15, 16, 17, 18, 19, 20:
					rIconY = 150;
				case 21, 22, 23, 24, 25, 26, 27, 28, 29, 30:
					rIconY = 300;
				case 31, 32, 33, 34, 35, 36, 37, 38, 39, 40:
					rIconY = 450;
				case 41, 42, 43, 44, 45, 46, 47, 48, 49, 50:
					rIconY = 600;
				case 51, 52, 53, 54, 55, 56, 57, 58, 59, 60: 
					rIconY = 750;
			}
			if (regIcon.animation.getByName('current') != null) {
				regIcon.animation.remove('current');
				regIcon.animation.play('default');
				regIcon.animation.add('current', [curValueRI], 0, false);
				regIcon.animation.play('current');
				regIconE.pixels.copyPixels(regIcon.framePixels, new openfl.geom.Rectangle(0, 0, regIconE.width, regIconE.height), new openfl.geom.Point(), null, null, true);
			} else {
				regIcon.animation.add('current', [curValueRI], 0, false);
				regIcon.animation.play('current');
				regIconE.pixels.copyPixels(regIcon.framePixels, new openfl.geom.Rectangle(0, 0, regIconE.width, regIconE.height), new openfl.geom.Point(), null, null, true);
			}
			trace(rIconX, rIconY);
		});
		var deaIconLEFT:FlxButton = new FlxButton(150, 170, '<--', function () {
			curValueDI -= 1;
			trace('current death icon: ' + curValueDI);
			if (curValueDI < 0) {
				curValueDI = 50;
			}
			if (curValueDI > 50) {
				curValueDI = 0;
			}
			switch (curValueDI) {
				case 0, 11, 21, 31, 41, 51:
					dIconX = 0;
				case 1, 12, 22, 32, 42, 52:
					dIconX = 150;
				case 2, 13, 23, 33, 43, 53:
					dIconX = 300;
				case 3, 14, 24, 34, 44, 54:
					dIconX = 450;
				case 4, 15, 25, 35, 45, 55:
					dIconX = 600;
				case 5, 16, 26, 36, 46, 56: 
					dIconX = 750;
				case 6, 17, 27, 37, 47, 57:
					dIconX = 900;
				case 7, 18, 28, 38, 48, 58:
					dIconX = 1050;
				case 8, 19, 29, 39, 49, 59:
					dIconX = 1200;
				case 10, 20, 30, 40, 50:
					dIconX = 1350;
			}
			switch (curValueDI) {
				case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10:
					dIconY = 0;
				case 11, 12, 13, 14, 15, 16, 17, 18, 19, 20:
					dIconY = 150;
				case 21, 22, 23, 24, 25, 26, 27, 28, 29, 30:
					dIconY = 300;
				case 31, 32, 33, 34, 35, 36, 37, 38, 39, 40:
					dIconY = 450;
				case 41, 42, 43, 44, 45, 46, 47, 48, 49, 50:
					dIconY = 600;
				case 51, 52, 53, 54, 55, 56, 57, 58, 59, 60: 
					dIconY = 750;
			}
			if (deaIcon.animation.getByName('current') != null) {
				deaIcon.animation.remove('current');
				deaIcon.animation.play('default');
				deaIcon.animation.add('current', [curValueDI], 0, false);
				deaIcon.animation.play('current');
				deaIconE.pixels.copyPixels(deaIcon.framePixels, new openfl.geom.Rectangle(0, 0, deaIconE.width, deaIconE.height), new openfl.geom.Point(), null, null, true);
			} else {
				deaIcon.animation.add('current', [curValueDI], 0, false);
				deaIcon.animation.play('current');
				deaIconE.pixels.copyPixels(deaIcon.framePixels, new openfl.geom.Rectangle(0, 0, deaIconE.width, deaIconE.height), new openfl.geom.Point(), null, null, true);
			}
			trace(dIconX, dIconY);
		});
		var deaIconRIGHT:FlxButton = new FlxButton(150, 190, '-->', function () {
			curValueDI += 1;
			trace('current death icon: ' + curValueDI);
			if (curValueDI < 0) {
				curValueDI = 50;
			}
			if (curValueDI > 50) {
				curValueDI = 0;
			}
			switch (curValueDI) {
				case 0, 11, 21, 31, 41, 51:
					dIconX = 0;
				case 1, 12, 22, 32, 42, 52:
					dIconX = 150;
				case 2, 13, 23, 33, 43, 53:
					dIconX = 300;
				case 3, 14, 24, 34, 44, 54:
					dIconX = 450;
				case 4, 15, 25, 35, 45, 55:
					dIconX = 600;
				case 5, 16, 26, 36, 46, 56: 
					dIconX = 750;
				case 6, 17, 27, 37, 47, 57:
					dIconX = 900;
				case 7, 18, 28, 38, 48, 58:
					dIconX = 1050;
				case 8, 19, 29, 39, 49, 59:
					dIconX = 1200;
				case 10, 20, 30, 40, 50:
					dIconX = 1350;
			}
			switch (curValueDI) {
				case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10:
					dIconY = 0;
				case 11, 12, 13, 14, 15, 16, 17, 18, 19, 20:
					dIconY = 150;
				case 21, 22, 23, 24, 25, 26, 27, 28, 29, 30:
					dIconY = 300;
				case 31, 32, 33, 34, 35, 36, 37, 38, 39, 40:
					dIconY = 450;
				case 41, 42, 43, 44, 45, 46, 47, 48, 49, 50:
					dIconY = 600;
				case 51, 52, 53, 54, 55, 56, 57, 58, 59, 60: 
					dIconY = 750;
			}
			if (deaIcon.animation.getByName('current') != null) {
				deaIcon.animation.remove('current');
				deaIcon.animation.play('default');
				deaIcon.animation.add('current', [curValueDI], 0, false);
				deaIcon.animation.play('current');
				deaIconE.pixels.copyPixels(deaIcon.framePixels, new openfl.geom.Rectangle(0, 0, deaIconE.width, deaIconE.height), new openfl.geom.Point(), null, null, true);
			} else {
				deaIcon.animation.add('current', [curValueDI], 0, false);
				deaIcon.animation.play('current');
				deaIconE.pixels.copyPixels(deaIcon.framePixels, new openfl.geom.Rectangle(0, 0, deaIconE.width, deaIconE.height), new openfl.geom.Point(), null, null, true);
			}
			trace(dIconX, dIconY);
		});
		deaIconLEFT.cameras = [pussy];
		deaIconRIGHT.cameras = [pussy];
		regIconLEFT.cameras = [pussy];
		regIconRIGHT.cameras = [pussy];
		iconManipulators.push(regIconLEFT);
		iconManipulators.push(regIconRIGHT);
		iconManipulators.push(deaIconLEFT);
		iconManipulators.push(deaIconRIGHT);
		add(regIconLEFT);
		add(regIconRIGHT);
		add(deaIconLEFT);
		add(deaIconRIGHT);
	}
	function inWetVagina(_):Void {
		// shart in my bussy
        bussyShart.removeEventListener(Event.SELECT, onLoadComplete);
		var bu:FlxSprite = new FlxSprite();
		bu.makeGraphic(1280, 26, FlxColor.BLACK);
		bu.y = FlxG.height - 26;
		var ssy:FlxText = new FlxText(0, bu.y - 4, FlxG.width, 'ERROR: File not loaded, did something go wrong?');
		ssy.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(bu);
		add(ssy);
		new FlxTimer().start(5, function (tmr:FlxTimer) {
			bu.kill();
			ssy.kill();
		});
		//return Event->StdTypes.Void;
	}
	function saveIconAndSet() {
		trace('test');
		var fuck:BitmapData = new BitmapData(300, 150, true, FlxColor.TRANSPARENT);
		var shit:Matrix = new Matrix();
		var ass:ByteArray = new ByteArray();
		var cum:FileOutput;
		cum = sys.io.File.write('mods/images/icons/icon-' + susName.text + '.png', true);
		shit.translate(150, 0);
		fuck.fillRect(fuck.rect, 0x00000000);
		// fuck.merge(regIcon.graphic.bitmap, new openfl.geom.Rectangle(rIconX, rIconY, 150, 150), new openfl.geom.Point(), 1, 1, 1, 1);
		// fuck.merge(deaIcon.graphic.bitmap, new openfl.geom.Rectangle(dIconX, dIconY, 150, 150), new openfl.geom.Point(150), 1, 1, 1, 1);
		// fuck.draw(regIconE.graphic.bitmap, null, new openfl.geom.ColorTransform(), openfl.display.BlendMode.ALPHA, new openfl.geom.Rectangle(rIconX, rIconY, 150, 150));
		// fuck.draw(deaIconE.graphic.bitmap, shit, new openfl.geom.ColorTransform(), openfl.display.BlendMode.ALPHA, new openfl.geom.Rectangle(dIconX, dIconY, 150, 150));
		fuck.copyPixels(deaIcon.pixels, new openfl.geom.Rectangle(dIconX, dIconY, 150, 150), new openfl.geom.Point(150), null, null, true);
		fuck.copyPixels(regIcon.pixels, new openfl.geom.Rectangle(rIconX, rIconY, 150, 150), new openfl.geom.Point(), null, null, true);
		fuck.encode(new openfl.geom.Rectangle(0,0,300,150), new openfl.display.PNGEncoderOptions(false), ass);
		fuck.getPixels(fuck.rect);
		trace(ass);
		cum.writeBytes(ass, 0, ass.length);
		cum.close();
		close();
	}
	function onLoadComplete(_):Void {
		bussyShart.removeEventListener(Event.SELECT, onLoadComplete);
        bussyShart.removeEventListener(Event.CANCEL, onLoadCancel);
        bussyShart.removeEventListener(IOErrorEvent.IO_ERROR, inWetVagina);

        var fullPath:String = '';

        if (@:privateAccess bussyShart.__path != null) fullPath = DevinsFileUtils.fixWinPath(@:privateAccess bussyShart.__path);
	}

	function onLoadCancel(_):Void {
		bussyShart.removeEventListener(Event.SELECT, onLoadComplete);
		bussyShart.removeEventListener(Event.CANCEL, onLoadCancel);
		bussyShart.removeEventListener(IOErrorEvent.IO_ERROR, inWetVagina);
        bussyShart = null;
		trace('aight');
	}
	override function update(elapsed:Float) {
		if (openButton != null) {
			openButton.update(elapsed);
		}
		if (doneButton != null) {
			doneButton.update(elapsed);
		}
		if (iconGrid != null) {
			iconGrid.update(elapsed);
		}
		if (iconManipulators.length > 0) {
			for (i in 0...iconManipulators.length) {
				if (iconManipulators[i] != null) {
					iconManipulators[i].update(elapsed);
				}
			}
		}
		if (susName != null) {
			susName.update(elapsed);
		}
	}

	function convertToLocalFile(file:String) {
		trace(file);
		#if windows
        if (!file.contains('/'))
		var haha = file.split('\\');
        else var haha = file.split('/');
		#else
		var haha = file.split('/');
		#end
		var gayShit:Array<String> = [];
		trace(haha);
		for (i in 0...haha.length) {
			if (haha[i].contains('mods') || haha[i].contains('images') || haha[i].contains('icongrids') || haha[i].endsWith('.png')) {
				trace(haha[i]);
				if (haha[i].endsWith('.png')) gayShit.push(haha[i]) else gayShit.push(haha[i] + '/');
			} else {
				trace('ass');
			}
		}
		return gayShit[0] + gayShit[1] + gayShit[2] + gayShit[3];
	}
	var fart(default, null):String;
}