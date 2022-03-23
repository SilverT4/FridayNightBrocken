package options;

import sys.FileSystem;
import flixel.addons.ui.FlxUIColorSwatch;
import haxe.Json;
import flixel.ui.FlxButton;
import randomShit.util.CustomRandom;
import ProfileThingy.DebugProfileSubstate;
import flixel.text.FlxText;
import randomShit.dumb.Cvm;
import MusicBeatSubstate;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIColorSwatchSelecter;
import flixel.util.FlxColor;
import FunkinLua;

using StringTools;

class CvmTextExample extends FlxText {
    static var CURFONT:String = 'VCR OSD MONO';
    static var CURSIZE:Int = 24;
    static var CURCOLOR:FlxColor = FlxColor.WHITE;
    static var CURALIGN:FlxTextAlign = LEFT;
    static var CURBORDER:FlxTextBorderStyle = OUTLINE;
    static var CURCOLOR_OUT:FlxColor = FlxColor.BLACK;
    static var BORDERENABLED:Bool = true;
    public var BorderStatus:Bool;
    public function new(x:Float, y:Float) {
        var EXAMPLE_MSG:String = DebugProfileSubstate.girlYes[CustomRandom.int(0, DebugProfileSubstate.girlYes.length)];
        super(x, y, 0, EXAMPLE_MSG, 24);
        setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        BorderStatus = BORDERENABLED;
    }

    public function changeFont(newFont:String) {
        this.setFormat(newFont);
        CURFONT = newFont;
    }

    public function changeSize(newSize:Int) {
        this.setFormat(CURFONT, newSize);
        CURSIZE = newSize;
    }

    public function changeTextColour(newColour:FlxColor) {
        this.setFormat(CURFONT, CURSIZE, newColour);
        CURCOLOR = newColour;
    }

    public function changeAlignment(Align:String) {
        this.setFormat(CURFONT, CURSIZE, CURCOLOR, Align);
        CURALIGN = Align;
    }

    public function toggleBorder(EnableBorder:Bool) {
        if (EnableBorder) {
            this.setFormat(CURFONT, CURSIZE, CURCOLOR, CURALIGN, OUTLINE, CURCOLOR_OUT);
            CURBORDER = OUTLINE;
        } else {
            this.setFormat(CURFONT, CURSIZE, CURCOLOR, CURALIGN, NONE, CURCOLOR_OUT);
            CURBORDER = NONE;
        }
        BORDERENABLED = !BORDERENABLED;
    }

    public function changeOutlineColour(newColour:FlxColor) {
        this.setFormat(CURFONT, CURSIZE, CURCOLOR, CURALIGN, CURBORDER, newColour);
        CURCOLOR_OUT = newColour;
    }

    public function resetExample() {
        this.text = DebugProfileSubstate.girlYes[CustomRandom.int(0, DebugProfileSubstate.girlYes.length)];
        trace(this.text);
    }

    public function grabNewFormatForSaving():CvmmyFormat {
        var TeslasCvm = {
            "Font_Name": CURFONT,
            "Font_Size": CURSIZE,
            "Font_Color": CURCOLOR,
            "Font_Align": CURALIGN,
            "OutlinesEnabled": BORDERENABLED,
            "Outline_Color": CURCOLOR_OUT
        };

        return cast Json.stringify(TeslasCvm, "\t");
    }

    public function getCurrentColor(Value:String):FlxColor {
        if (Value == 'TEXT') return CURCOLOR else return CURCOLOR_OUT;
    }

    public function getCurrentAlign():String {
        return Std.string(CURALIGN);
    }
}
class CvmFormatManager extends MusicBeatSubstate {
    public static var Custom_Formats:Map<String, CvmmyFormat> = [];
    static final templateCvm:String = '{
        "Font_Name": "VCR OSD Mono",
        "Font_Size": 24,
        "Font_Color": ' + FlxColor.WHITE + ',
        "Font_Align": "LEFT",
        "OutlinesEnabled": true,
        "Outline_Color": ' + FlxColor.BLACK + '
    }';
    var CUR_FORMAT:CvmmyFormat;
    var FormatUI:FlxUITabMenu;
    var UIShit:FlxUI;
    var BlockInput:Bool = false;
    var BlockWhileTypingIn:Array<FlxUIInputText> = [];
    var BlockWhileSelectingFrom:Array<FlxUIDropDownMenuCustom> = [];
    var exampleText:CvmTextExample;

    public function new() {
        super();
        if (FlxG.save.data.customCvms != null) {
            Custom_Formats = FlxG.save.data.customCvms;
        }
        CUR_FORMAT = cast Json.parse(templateCvm);
        #if debug
        FlxG.log.redirectTraces = true;
        #end
    }

    override function create() {
        FlxG.sound.playMusic(Paths.music('DaveDialogue'), 0.7);
        var bg:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 0, 0, 128));
        add(bg);
        var tabs = [
            {name: 'Format', label: 'Format'}
        ];
        FormatUI = new FlxUITabMenu(null, tabs);
        FormatUI.resize(250, 300);
        FormatUI.scrollFactor.set();
        FormatUI.setPosition(FlxG.width - 275);
        add(FormatUI);
        exampleText = new CvmTextExample(0, FlxG.height - 120);
        createUIShit();
        FlxG.mouse.visible = true;
        FlxG.mouse.useSystemCursor = true;
        add(exampleText);
    }
    var CURRENT_FOCUSED_INPUTTER:FlxUIInputText;
    override function update(elapsed:Float) {
        for (inputter in BlockWhileTypingIn) {
            if (inputter.hasFocus) {
                BlockInput = true;
                CURRENT_FOCUSED_INPUTTER = inputter;
                break;
            } else {
                if (CURRENT_FOCUSED_INPUTTER != null && CURRENT_FOCUSED_INPUTTER.hasFocus) {
                    return;
                } else if (CURRENT_FOCUSED_INPUTTER != null && !CURRENT_FOCUSED_INPUTTER.hasFocus) {
                    CURRENT_FOCUSED_INPUTTER = null;
                    BlockInput = false;
                    break;
                }
            }
        }

        if (!BlockInput) {
            if (controls.BACK) {
                FlxG.sound.play(Paths.sound('cancelMenu'), 1, false, null, true, exitSubstate);
            }
            if (controls.RESET) {
                exampleText.resetExample();
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

            #if debug
            if (FlxG.keys.justPressed.L) {
                trace(exampleText.grabNewFormatForSaving());
            }
            #end
        }

        super.update(elapsed);
    }

    function exitSubstate() {
        close();
    }

    override function close() {
        #if debug
        FlxG.log.redirectTraces = false;
        #end
        FlxG.sound.playMusic(Paths.music('desktop'));
        FlxG.save.flush();
        super.close();
    }

    function createUIShit() {
        UIShit = new FlxUI(null, FormatUI);
        UIShit.name = 'Format';

        var fontNameInput = new FlxUIInputText(15, 30, 150, 'VCR OSD Mono', 8);
        BlockWhileTypingIn.push(fontNameInput);

        var fontSizeInput = new FlxUIInputText(fontNameInput.x + 160, 30, 50, '24', 8);
        BlockWhileTypingIn.push(fontSizeInput);

        var fontColorButton = new FlxButton(15, 180, 'Set font color', changeFontColor);

        var fontAlignDropDown = new FlxUIDropDownMenuCustom(fontNameInput.x, fontNameInput.y + 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray(['Left', 'Center', 'Right'], false), function(align:String) {
            trace('peen');
            exampleText.changeAlignment(align.toLowerCase());
        });
        fontAlignDropDown.selectedLabel = exampleText.getCurrentAlign();
        BlockWhileSelectingFrom.push(fontAlignDropDown);

        var outlineCheckBox = new FlxUICheckBox(fontAlignDropDown.x + 160, fontAlignDropDown.y, null, null, 'Has outline?', 100, null, function() {
            exampleText.toggleBorder(!exampleText.BorderStatus);
        });
        outlineCheckBox.checked = exampleText.BorderStatus;

        var outlineColorButton = new FlxButton(fontColorButton.x + 110, fontColorButton.y, 'Set outline color', changeOutlineColor); // maybe these will use lua for errors??

        var pathButton = new FlxButton(outlineColorButton.x / fontColorButton.x, fontColorButton.y + 30, 'Use Paths', openPathSubs);

        UIShit.add(new FlxText(fontNameInput.x, fontNameInput.y - 18, 0, 'Font name', 8));
        UIShit.add(new FlxText(fontSizeInput.x, fontSizeInput.y - 18, 0, 'Size', 8));
        UIShit.add(new FlxText(fontAlignDropDown.x, fontAlignDropDown.y - 18, 0, 'Alignment', 8));
        UIShit.add(fontNameInput);
        UIShit.add(fontSizeInput);
        UIShit.add(fontColorButton);
        UIShit.add(fontAlignDropDown);
        UIShit.add(outlineCheckBox);
        UIShit.add(outlineColorButton);
        UIShit.add(pathButton);
        FormatUI.addGroup(UIShit);
    }

    function openPathSubs() {
        openSubState(new FontPathing());
    }

    function changeFontColor() {
        throw new haxe.Exception(DebugProfileSubstate.girlYes[CustomRandom.int(0, DebugProfileSubstate.girlYes.length)]);//openSubState(new FontColorSetter());
    }

    function changeOutlineColor() {
        trace('I LOVE LEAN!!!');
    }
}

class FontColorSetter extends CvmFormatManager {
    var colorThing:FlxUIColorSwatchSelecter;
    public function new() {
        super();
        colorThing = new FlxUIColorSwatchSelecter(0, 0, null, [exampleText.getCurrentColor('TEXT')], null, null, 2, 2, -1, null, null);
        add(colorThing);
    }
}

/**Allows the use of Paths.*/
class FontPathing extends CvmFormatManager {
    var fontNameList:Array<String> = FileSystem.readDirectory('assets/fonts');
    var modFonts = FileSystem.readDirectory('mods/' + Paths.currentModDirectory + '/fonts');
    var fontUI:FlxUITabMenu;
    var fontass:FlxUI;
    var fontlisttext:FlxText;
    var fontinput:FlxUIInputText;
    public function new () {
        super();
        trace(fontNameList);
        trace(modFonts);
        fontNameList.concat(modFonts);
        trace(fontNameList);
        /*if (modFonts != null) {
            if (modFonts.length > 0) for (i in 0...modFonts.length) {
                fontNameList.push(modFonts[i]);
            }
        } */
    }

    override function create() {
        var tabs = [
            {name: 'font', label: 'font'}
        ];
        fontUI = new FlxUITabMenu(null, tabs);
        fontUI.resize(250, 150);
        fontUI.setPosition(0, 15);
        fontUI.scrollFactor.set();
        fontlisttext = new FlxText(275, 15, 0, fontNameList.join('\n'), 8);
        add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(69, 69, 69, 69)));
        add(fontUI);
        add(fontlisttext);
        addfontshit();
    }

    function addfontshit() {
        trace('lean');
        fontass = new FlxUI(null, fontUI);
        fontass.name = 'font';

        fontinput = new FlxUIInputText(15, 30, 200, exampleText.grabNewFormatForSaving().Font_Name, 8);
        var okbutton = new FlxButton(fontinput.x + 210, fontinput.y, 'ok', function() {
            exampleText.changeFont(Paths.font(fontinput.text));
            close();
        });

        fontass.add(new FlxText(fontinput.x, fontinput.y - 18, 0, 'Font name', 8));
        fontass.add(fontinput);
        fontass.add(okbutton);
        fontUI.addGroup(fontass);
    }
}