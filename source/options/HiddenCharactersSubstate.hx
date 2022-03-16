package options;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUI;
import flixel.ui.FlxButton;
import random.util.CheckinMultiple;
import options.OptionsState;
import options.OptionsStateExtra;
import options.BaseOptionsMenu;
import options.Option;

using StringTools;

class HiddenCharactersSubstate extends MusicBeatSubstate {
    var UIBox:FlxUITabMenu;
    var UIStuff:FlxUI;
    var hiddenCharList:Array<String> = [];
    var InputBox:FlxUIInputText;
    var updateButton:FlxButton;
    var resetButton:FlxButton;
    var showListButton:FlxButton;

    public function new() {
        if (FlxG.save.data.hideCharList != null) {
            trace('found existing list!');
            hiddenCharList = FlxG.save.data.hideCharList; // makes it easier to modify after first time
        }
        if (!FlxG.mouse.visible) FlxG.mouse.visible = true;
        super();
    }

    override function create() {
        var tabs = [
            { name: 'Character List', label: 'Character List' }
        ];
        UIBox = new FlxUITabMenu(null, tabs);
        UIBox.resize(250, 150);
        UIBox.screenCenter();
        UIBox.scrollFactor.set();
        UIBox.updateHitbox();
        add(UIBox);
    }

    override function update(elapsed:Float) {
        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'), 1, false, null, true, function() {
                close();
            });
        }

        super.update(elapsed);
    }
}