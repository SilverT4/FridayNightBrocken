package random.dumb;

import random.util.DevinsFileUtils;
import random.util.DumbUtil;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;

/**Cvm message format system.
    
@param Font_Name The font name you want to use. Can also be a `Paths.font` input
@param Font_Size The size of the font.
@param Font_Color The text colour. You can use `FlxColor` or a HEX code.
@param Font_Align Alignment. Values: `LEFT`, `CENTER`, `RIGHT`
@param OutlinesEnabled Choose whether your message has outlines or not.
@param Outline_Color The outline colour. Just set it to `FlxColor.BLACK` if you set OutlinesEnabled to false.*/
typedef CvmmyFormat = {
    var Font_Name:String;
    var Font_Size:Int;
    var Font_Color:FlxColor;
    var Font_Align:FlxTextAlign;
    var OutlinesEnabled:Bool;
    var Outline_Color:FlxColor;
}


class CvmWarnScreen extends FlxSprite {
    var defaultAlpha:Float = 0.69; // for if alpha isn't provided.
    @:noCompletion var __ThisShit:FlxTypedGroup<Dynamic>;
    public var callMeShitty:FlxTypedGroup<Dynamic>;
    var msgId:Int = 0;
    public function new(col:FlxColor, ?alph:Float){
        super(0, 0);
        makeGraphic(FlxG.width, FlxG.height, col);
        if (alph != null) {
            alpha = alph;
        } else {
            alpha = defaultAlpha;
        }
        __ThisShit = new FlxTypedGroup<Dynamic>();
        callMeShitty = new FlxTypedGroup<Dynamic>();
    }

    static final defaultFormats:Map<String, String> = [
        'fnf_24-OUT' => '{
            "Font_Name": "VCR OSD Mono",
            "Font_Size": 24,
            "Font_Color": ' + FlxColor.WHITE + ',
            "Font_Align": "LEFT",
            "OutlinesEnabled": true,
            "Outline_Color": ' + FlxColor.BLACK + '
        }',
        'fnf_24' => '{
            "Font_Name": "VCR OSD Mono",
            "Font_Size": 24,
            "Font_Color": ' + FlxColor.WHITE + ',
            "Font_Align": "LEFT",
            "OutlinesEnabled": false,
            "Outline_Color": ' + FlxColor.BLACK + '
        }',
        'nds_32-OUT' => '{
            "Font_Name": "Nintendo DS BIOS Regular",
            "Font_Size": 32,
            "Font_Color": ' + FlxColor.WHITE + ',
            "Font_Align": "LEFT",
            "OutlinesEnabled": true,
            "Outline_Color": ' + FlxColor.BLACK + '
        }',
        'nds_32' => '{
            "Font_Name": "Nintendo DS BIOS Regular",
            "Font_Size": 24,
            "Font_Color": ' + FlxColor.WHITE + ',
            "Font_Align": "LEFT",
            "OutlinesEnabled": false,
            "Outline_Color": ' + FlxColor.BLACK + '
        }'
    ];
    /**Add an error message to the screen.
    @param yPos Y position
    @param errText Error message
    @param fsize Font size*/
    public function attachError(yPos:Float, errText:String, fsize:Int) {
        var errorMsg:CvmError = new CvmError(yPos, errText, fsize);
        errorMsg.setID(msgId);
        __ThisShit.add(errorMsg);
        callMeShitty.add(errorMsg);
        msgId++;
    }

    /**Add a warning message to the screen.
    @param yPos Y position
    @param errText Error message
    @param fsize Font size*/
    public function attachWarning(yPos:Float, warText:String, fsize:Int) {
        var warnMsg:CvmError = new CvmError(yPos, warText, fsize);
        warnMsg.setID(msgId);
        __ThisShit.add(warnMsg);
        callMeShitty.add(warnMsg);
        msgId++;
    }

    /**Add an info message to the screen.
    @param yPos Y position
    @param errText Error message
    @param fsize Font size*/
    public function attachInfo(yPos:Float, infText:String, fsize:Int) {
        var infoMsg:CvmError = new CvmError(yPos, infText, fsize);
        infoMsg.setID(msgId);
        __ThisShit.add(infoMsg);
        callMeShitty.add(infoMsg);
        msgId++;
    }
    /**Change the format of a message.
    @param msgIDNo The ID number. You can get an ID by calling `getMsgIDNo(MsgText)`.
    @param newFormat The format. Check the `CvmmyFormat` typedef to see how to create one.*/
    public function setMsgFormat(msgIDNo:Int, newFormat:CvmmyFormat) {
        if (__ThisShit.members[msgIDNo] != null) {
            __ThisShit.members[msgIDNo].changeFormat(newFormat.Font_Name, newFormat.Font_Size, newFormat.Font_Color, newFormat.Font_Align, newFormat.OutlinesEnabled, newFormat.Outline_Color);
            trace('new format should be set!');
        }
    }
    /**Provides a few default formats for the Cvm messages.
        
    ### **Default format names**
    
    `fnf_24`, `fnf_24-OUT`, `nds_32`, `nds_32-OUT`*/
    public function defaultFormat(FormatName:String):CvmmyFormat {
        return DevinsFileUtils.parseJsonString(defaultFormats[FormatName]);
    }


}

class CvmMessage extends FlxSprite {
    var msgTypes:Map<String, FlxColor> = [
        'ERROR' => FlxColor.fromRGB(255, 0, 0, 128),
        'WARNING' => FlxColor.fromRGB(255, 128, 0, 128),
        'INFO' => FlxColor.fromRGB(0, 0, 0, 128)
    ];
    public var msgType:String = '';
    public var msgId:Int = 0;
    public function new(y:Float, msgType:String, height:Int) {
        super(0, y);
        makeGraphic(FlxG.width, height, msgTypes[msgType]);
    }

    /*inline function changeFormats(FontName:String, FontSize:Int, TextColour:FlxColor, TextAlign:FlxTextAlign, UsesOutlines:Bool, ?OutlineColour:FlxColor) {
        if (UsesOutlines && OutlineColour != null) {

        }
    } */

    public function setID(IDNo:Int) {
        msgId = IDNo;
        trace('ID now ' + IDNo);
    }

    public function getID():Int {
        return msgId;
    }
}

class CvmError extends CvmMessage {
    var msgFontSize:Int = 8; // FLIXEL DEFAULT IS DEFAULT HERE.
    @:noPrivateAccess var msg:FlxText;
    static inline final DEFALT_FONT = "VCR OSD Mono";
    static final DEFAULT_COLOURS:Map<String, FlxColor> = [
        'text' => FlxColor.WHITE,
        'outline' => FlxColor.BLACK
    ];
    public function new(y:Float, msgText:String, fontSize:Int) {
        super(y, "ERROR", fontSize + 4);
        msgType = 'ERROR';
        msg = new FlxText(0, super.y + 4, 0, msgText, fontSize);
        msg.scrollFactor.set();
        setDefaultFormat(fontSize);
    }

    inline function setDefaultFormat(FontSize:Int) {
        msg.setFormat(DEFALT_FONT, FontSize, DEFAULT_COLOURS['text'], LEFT, OUTLINE, DEFAULT_COLOURS['outline']);
    }

    public inline function changeFormats(FontName:String, FontSize:Int, TextColour:FlxColor, TextAlign:FlxTextAlign, UsesOutlines:Bool, ?OutlineColour:FlxColor) {
        if (UsesOutlines && OutlineColour != null) {
            msg.setFormat(FontName, FontSize, TextColour, TextAlign, FlxTextBorderStyle.OUTLINE, OutlineColour);
        } else if (UsesOutlines) {
            msg.setFormat(FontName, FontSize, TextColour, TextAlign, OUTLINE, DEFAULT_COLOURS['outline']);
        } else {
            msg.setFormat(FontName, FontSize, TextColour, TextAlign);
        }
    }
}

class CvmWarning extends CvmMessage {
    var msgFontSize:Int = 8; // FLIXEL DEFAULT IS DEFAULT HERE.
    @:noPrivateAccess var msg:FlxText;
    static inline final DEFALT_FONT = "VCR OSD Mono";
    static final DEFAULT_COLOURS:Map<String, FlxColor> = [
        'text' => FlxColor.WHITE,
        'outline' => FlxColor.BLACK
    ];
    public function new(y:Float, msgText:String, fontSize:Int) {
        super(y, "WARNING", fontSize + 4);
        msgType = 'WARNING';
        msg = new FlxText(0, y + 4, 0, msgText, fontSize);
        msg.scrollFactor.set();
        setDefaultFormat(fontSize);
    }

    inline function setDefaultFormat(FontSize:Int) {
        msg.setFormat(DEFALT_FONT, FontSize, DEFAULT_COLOURS['text'], LEFT, OUTLINE, DEFAULT_COLOURS['outline']);
    }

    public inline function changeFormats(FontName:String, FontSize:Int, TextColour:FlxColor, TextAlign:FlxTextAlign, UsesOutlines:Bool, ?OutlineColour:FlxColor) {
        if (UsesOutlines && OutlineColour != null) {
            msg.setFormat(FontName, FontSize, TextColour, TextAlign, FlxTextBorderStyle.OUTLINE, OutlineColour);
        } else if (UsesOutlines) {
            msg.setFormat(FontName, FontSize, TextColour, TextAlign, OUTLINE, DEFAULT_COLOURS['outline']);
        } else {
            msg.setFormat(FontName, FontSize, TextColour, TextAlign);
        }
    }
    
}

class CvmInfo extends CvmMessage {
    var msgFontSize:Int = 8; // FLIXEL DEFAULT IS DEFAULT HERE.
    @:noPrivateAccess var msg:FlxText;
    static inline final DEFALT_FONT = "VCR OSD Mono";
    static final DEFAULT_COLOURS:Map<String, FlxColor> = [
        'text' => FlxColor.WHITE,
        'outline' => FlxColor.BLACK
    ];
    public function new(y:Float, msgText:String, fontSize:Int) {
        super(y, "INFO", fontSize + 4);
        msgType = 'INFO';
        msg = new FlxText(0, y + 4, 0, msgText, fontSize);
        msg.scrollFactor.set();
        setDefaultFormat(fontSize);
    }

    inline function setDefaultFormat(FontSize:Int) {
        msg.setFormat(DEFALT_FONT, FontSize, DEFAULT_COLOURS['text'], LEFT, OUTLINE, DEFAULT_COLOURS['outline']);
    }

    public inline function changeFormats(FontName:String, FontSize:Int, TextColour:FlxColor, TextAlign:FlxTextAlign, UsesOutlines:Bool, ?OutlineColour:FlxColor) {
        if (UsesOutlines && OutlineColour != null) {
            msg.setFormat(FontName, FontSize, TextColour, TextAlign, FlxTextBorderStyle.OUTLINE, OutlineColour);
        } else if (UsesOutlines) {
            msg.setFormat(FontName, FontSize, TextColour, TextAlign, OUTLINE, DEFAULT_COLOURS['outline']);
        } else {
            msg.setFormat(FontName, FontSize, TextColour, TextAlign);
        }
    }
    
}