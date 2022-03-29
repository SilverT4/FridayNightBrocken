package editors.soundtrack.colour;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class ColourPreviewSquare extends FlxSprite {
    public function new(Colour:FlxColor) {
        super();
        makeGraphic(64, 64, Colour);
        screenCenter();
    }

    public function updateColor(NewColour:FlxColor) {
        color = NewColour;
    }

    public function updateColorFromRGB(NewRGB:Array<Int>) {
        color = FlxColor.fromRGB(NewRGB[0], NewRGB[1], NewRGB[2]);
    }

    public function updateFromSCI(NewSCI:randomShit.dumb.SoundtrackMenu.SongColorInfo) {
        color = FlxColor.fromRGB(NewSCI.red, NewSCI.green, NewSCI.blue);
    }
}