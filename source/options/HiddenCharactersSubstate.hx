package options;

import flixel.util.FlxColor;
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
import random.dumb.Cvm;

using StringTools;

class HiddenCharactersSubstate extends MusicBeatSubstate {
    var UIBox:FlxUITabMenu;
    var UIStuff:FlxUI;
    var hiddenCharList:Array<String> = [];
    var tempList:Array<String> = [];
    var InputBox:FlxUIInputText;
    var updateButton:FlxButton;
    var resetButton:FlxButton;
    var showListButton:FlxButton;
    var unsavedChanges:Bool = false;

    public function new() {
        if (ClientPrefs.hideCharList != null) {
            trace('found existing list!');
            hiddenCharList = ClientPrefs.hideCharList; // makes it easier to modify after first time
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
        //UIBox.scrollFactor.set(); // will removing this fix the box not appearing in the right place???
        UIBox.updateHitbox();
        add(UIBox);
    }

    override function update(elapsed:Float) {
        if (controls.BACK) {
            if (!unsavedChanges) {
                FlxG.sound.play(Paths.sound('cancelMenu'), 1, false, null, true, function() {
                close();
            });
        } else if (wbg != null) {
            for (ms in wbg.callMeShitty) {
                ms.destroy();
                ms = null;
            }
            wbg.destroy();
            wbg = null;
        } else {
            trace('oh hold up');
            warnUnsavedChanges();
        }
        }

        if (controls.ACCEPT && wbg != null) {
            close();
        }

        if (InputBox != null && InputBox.hasFocus) {
            if (FlxG.keys.justPressed.ENTER) {
                trace('update list...');
                hiddenCharList = InputBox.text.split(',');
                unsavedChanges = false;
            }
            tempList = InputBox.text.split(',');
        }

        if (tempList != null) {
            if (tempList.length >= 1 && tempList != hiddenCharList && !unsavedChanges) {
                unsavedChanges = true;
            }
        }

        super.update(elapsed);
    }
    var wbg:CvmWarnScreen;
    function warnUnsavedChanges():Void {
        wbg = new CvmWarnScreen(FlxColor.fromRGB(0, 0, 0), 0.69);
        wbg.attachWarning(0, 'Are you sure you want to exit? You have unsaved changes!', 24);
        add(wbg);
        for (ms in wbg.callMeShitty) {
            add(ms);
        }
    }
}