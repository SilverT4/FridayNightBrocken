package;

import SelectChara.CharSelShit;
import flixel.FlxG;
import flixel.FlxSprite;
import Character;
import flixel.text.FlxText;
import randomShit.util.HintMessageAsset;
import randomShit.dumb.FunkyBackground; // for songs WITHOUT a bg already, that's stayin from the original
import openfl.utils.Assets as OpenAssets;
import Alphabet;
import HealthIcon;
import flixel.group.FlxGroup.FlxTypedGroup;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
using StringTools;

/**The new and improved selectable character typedef! Now with an icon field.
@param CharName The character's name on its JSON file. If you hardcode a character, just hardcode it in this class as well.
@param DeathName (Optional) If your character has a separate character for death sprites, put it here.
@param IconName (Optional) Allows you to change the character's icon. By default, the game will use the icon associated with the character file.
@param hasHey Do they have a hey animation?
@param HeyName (Optional if hasHey is false) Name the hey animation. Usually "hey" or "cheer".
@param FriendlyName This name gets displayed on the select screen.
@since April 2022 (Emo Engine 0.2.0)*/
typedef SelectableFile = {
    var CharName:String;
    var ?DeathName:String;
    var ?IconName:String;
    var hasHey:Bool;
    var ?HeyName:String;
    var FriendlyName:String;
}
/**This is a rework of the SelectChara class and its typedef! I'm *hoping* this will be a lot easier to work with.
@since April 2022 (Emo Engine 0.2.0)*/
class NewCharacterSelect extends MusicBeatState {
    public static var skipped:Bool = false; // this gets set when you load prefs
    private static var Default_Boyfriend:SelectableFile = {
        CharName: "bf",
        hasHey: true,
        HeyName: "hey",
        FriendlyName: "Boyfriend"
    };
    private static var Default_BF_Car:SelectableFile = {
        CharName: "bf-car",
        hasHey: false,
        FriendlyName: "Boyfriend (Car)",
        DeathName: "bf"
    };
    private static var Default_BF_Christmas:SelectableFile = {
        CharName: "bf-christmas",
        hasHey: true,
        HeyName: "hey",
        FriendlyName: "Festive Boyfriend",
        DeathName: "bf"
    };
    private static var Default_Pixel_BF:SelectableFile = {
        CharName: "bf-pixel",
        hasHey: false,
        FriendlyName: "Pixel Boyfriend",
        DeathName: "bf-pixel-dead"
    };
    private var Character_List:Array<SelectableFile> = [];
    private var NoSongBg:FunkyBackground;
    private var SongBg:FlxSprite;
    private var grpName:FlxTypedGroup<Alphabet>;
    private var iconArray:Array<HealthIcon> = [];
    private var songHasBack:Bool = false;
    var baseList:Array<String> = [
        'tutorial',
        'bopeebo',
        'fresh',
        'dad-battle',
        'spookeez',
        'south',
        'monster',
        'pico',
        'philly-nice',
        'blammed',
        'satin-panties',
        'high',
        'milf',
        'cocoa',
        'eggnog',
        'winter-horrorland',
        'senpai',
        'roses',
        'thorns'
    ];
    public function new() {
        super();
        if (PlayState.SONG != null) { // This is to prevent potential crashes.
            if (BackgroundUtil.hasBackground(PlayState.SONG.song, baseList.contains(PlayState.SONG.song.toLowerCase()))) {
                trace("SONG HAS BG!");
                songHasBack = true;
            } else {
                songHasBack = false;
            }
        
        }
        getTheCharas();
        //CharacterUtil.checkAndFixJsons();
    }

    override function create() {
        if (!FlxG.sound.music.playing) {
            FlxG.sound.playMusic(Paths.music('mktFriends'));
        }
        if (songHasBack) {
            SongBg = new FlxSprite();
            SongBg.loadGraphic(BackgroundUtil.getBackground(PlayState.SONG.song, baseList.contains(PlayState.SONG.song.toLowerCase())));
            add(SongBg);
        } else {
            NoSongBg = new FunkyBackground();
            NoSongBg.setColor(0xFF696969, false);
            add(NoSongBg);
        }
        grpName = new FlxTypedGroup<Alphabet>();
        add(grpName);
        var dildo = 0;
        for (dumbass in Character_List) {
            trace("Adding " + (dildo + 1) + " of " + Character_List.length + ": " + dumbass.FriendlyName + " (" + dumbass.CharName + ")");
            var nameText = new Alphabet(0, (70 * dildo), dumbass.FriendlyName, true, false);
            nameText.isMenuItem = true;
            nameText.targetY = dildo;
            grpName.add(nameText);
            var dick = (dumbass.IconName != null) ? dumbass.IconName : CharacterUtil.getIcon(dumbass.CharName);
            var icon:HealthIcon = new HealthIcon(dick);
            icon.sprTracker = nameText;
            add(icon);
            iconArray.push(icon);
            dildo++;
        }
        changeSelection();
        super.create();
    }
    var curSelected:Int = 0;
    function changeSelection(change:Int = 0) {
        curSelected += change;
        if (curSelected < 0) {
            curSelected = Character_List.length - 1;
        }
        if (curSelected >= Character_List.length) {
            curSelected = 0;
        }

        for (icon in iconArray) {
            icon.alpha = 0.6;
        }
        iconArray[curSelected].alpha = 1;

        var bullShit:Int = 0;
        for (item in grpName.members) {
            item.targetY = bullShit - curSelected;
            bullShit++;

            item.alpha = 0.6;

            if (item.targetY == 0) {
                item.alpha = 1;
            }
        }
        myMom = Character_List[curSelected].CharName;
        hasBigBooba = Character_List[curSelected].hasHey;
        butIDontFlex = (hasBigBooba) ? Character_List[curSelected].HeyName : "shitting";
    }

    function getTheCharas() {
        var defaultBf:Bool = true;
        var defaultChBf:Bool = false;
        var defaultCarBf:Bool = false;
        var defaultPixBf:Bool = false;
        Character_List = CharacterUtil.getCharacters();
        if (Character_List.length > 0) {
            for (idiot in Character_List) {
                if (idiot.CharName == 'bf') {
                    trace("WE DON'T NEED THE DEFAULT BF!!");
                    defaultBf = false;
                }
                if (idiot.CharName == 'bf-car') {
                    trace("WE DON'T NEED THE DEFAULT BF CAR!!");
                    defaultCarBf = false;
                }
                if (idiot.CharName == 'bf-christmas') {
                    trace("WE DON'T NEED THE DEFAULT BF CHRISTMAS!!");
                    defaultChBf = false;
                }
                if (idiot.CharName == 'bf-pixel') {
                    trace("WE DON'T NEED THE DEFAULT PIXEL BF!!");
                    defaultPixBf = false;
                }
            }
        }
        if (defaultBf) Character_List.insert(0, Default_Boyfriend);
        if (defaultCarBf) Character_List.insert(1, Default_BF_Car);
        if (defaultChBf) Character_List.insert(2, Default_BF_Christmas);
        if (defaultPixBf) Character_List.insert(3, Default_Pixel_BF); // get defaults in
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (controls.UI_DOWN_P) {
            changeSelection(1);
        }
        if (controls.UI_UP_P) {
            changeSelection(-1);
        }
        if (controls.ACCEPT) {
            openSubState(new CharacterPreview(myMom, hasBigBooba, butIDontFlex));
        }
        if (controls.BACK) {
            if (PlayState.isStoryMode) {
                LoadingState.loadAndSwitchState(new StoryMenuState());
            } else {
                LoadingState.loadAndSwitchState(new FreeplayState());
            }
        }
    }
    var myMom:String = 'bf';
    var hasBigBooba:Bool = true;
    var butIDontFlex:String = 'thatShit';
}

class BackgroundUtil {
    private static final Base_Mod_Path:String = 'mods/images/songBack/';
    private static final Base_Game_Path:String = 'assets/images/songBack/';
    public static function getBackground(SongName:String, isMod:Bool = false) {
        if (isMod) {
            var Dir_Mod_Path = 'mods/' + Paths.currentModDirectory + '/images/songBack/';
                if (OpenAssets.exists(Dir_Mod_Path + SongName.toLowerCase() + '.png', IMAGE)) {
                    return Dir_Mod_Path + SongName.toLowerCase() + '.png';
                } else if (OpenAssets.exists(Base_Mod_Path + SongName.toLowerCase() + '.png', IMAGE)) {
                    return Base_Mod_Path + SongName.toLowerCase() + '.png';
                } else return 'assets/images/menuDesat.png';
        } else {
            if (OpenAssets.exists(Base_Game_Path + SongName.toLowerCase() + '.png', IMAGE)) {
                return Base_Game_Path + SongName.toLowerCase() + '.png';
            } else return 'assets/images/menuDesat.png';
        }
    }
    public static function hasBackground(SongName:String, isMod:Bool):Bool {
        if (isMod) {
            if (Paths.currentModDirectory.length > 0) {
                var Dir_Mod_Path = 'mods/' + Paths.currentModDirectory + '/images/songBack/';
                if (OpenAssets.exists(Dir_Mod_Path + SongName.toLowerCase() + '.png', IMAGE)) {
                    return true;
                } else if (OpenAssets.exists(Base_Mod_Path + SongName.toLowerCase() + '.png', IMAGE)) {
                    return true;
                } else return false;
            } else {
                if (OpenAssets.exists(Base_Mod_Path + SongName.toLowerCase() + '.png', IMAGE)) {
                    return true;
                } else return false;
            }
        } else {
            if (OpenAssets.exists(Base_Game_Path + SongName.toLowerCase() + '.png', IMAGE)) {
                return true;
            } else return false;
        }
    }
}

class CharacterUtil {
    public static function getCharacters() {
        var toYeet:Array<SelectableFile> = [];
        #if MODS_ALLOWED
        var penisDir:String;
        if (Paths.currentModDirectory != null) {
            penisDir = Paths.currentModDirectory;
            var peen:Array<String> = [];
            var shit:Array<SelectableFile> = [];
            if (penisDir.length >= 1) {
                trace('I should check $penisDir.');
                if (FileSystem.exists('mods/$penisDir/selectable')) {
                    peen = FileSystem.readDirectory('mods/$penisDir/selectable');
                    for (penis in peen) {
                        if (isJson(penis)) {
                            shit.push(bullShit('mods/$penisDir/selectable/$penis'));
                        }
                    }
                }
                if (shit.length >= 1) {
                    for (sus in shit) toYeet.push(sus);
                }
            }
        }
        var modDir:String = 'mods/selectable/';
        var piss:Array<String> = FileSystem.readDirectory(modDir);
        var fard:Array<SelectableFile> = [];
        for (lemon in piss) {
            if (isJson(lemon)) {
                fard.push(bullShit(modDir + lemon));
            }
        }
        if (fard.length >= 1) {
            for (squid in fard) toYeet.push(squid);
        }
        #end
        return toYeet;
    }

    static function isJson(FileName:String) {
        return FileName.contains('.json');
    }
    static function bullShit(FilePath:String):Dynamic {
        return cast haxe.Json.parse(File.getContent(FilePath));
    }
    public static function getIcon(CharName:String) {
        var piss = bullShit(Paths.characterJson(CharName));
        return piss.healthicon;
    }
    public static function checkAndFixJsons() {
        trace("Checking jsons!");
        var needFix:Int = 0;
        var theseSpecifically:Array<Dynamic> = [];
        var pathyShit:String = 'mods/selectable/';
        var initList = FileSystem.readDirectory('mods/selectable');
        if (initList.length >= 1) {
            for (file in initList) {
                if (isJson(file)) {
                    var CharFile:Dynamic = bullShit(pathyShit + file);
                    if (CharFile.friendlyName != null && CharFile.characterName != null && CharFile.heyName != null && CharFile.deathCharacter != null) {
                        trace("This appears to be an older JSON!\n" + CharFile);
                        theseSpecifically.push([file, CharFile]);
                        needFix = theseSpecifically.length;
                    } else {
                        trace("this one is fine.\n" + CharFile);
                    }
                }
            }
        }
        if (needFix >= 1) {
            trace("Now attempting to fix the files.");
            var semen:String = "\t";
            for (impostor in theseSpecifically) {
                var savePath = pathyShit + impostor[0];
                var fuckMe:CharSelShit = impostor[1];
                var fileInt = theseSpecifically.indexOf(impostor) + 1;
                var shitToSave:SelectableFile = {
                    CharName: fuckMe.characterName,
                    FriendlyName: fuckMe.friendlyName,
                    hasHey: fuckMe.hasHey
                };
                if (fuckMe.hasHey) {
                    shitToSave.HeyName = fuckMe.heyName;
                }
                if (fuckMe.deathCharacter != fuckMe.characterName) {
                    shitToSave.DeathName = fuckMe.deathCharacter;
                }
                trace("Saving file " + fileInt + " of " + theseSpecifically.length + ": " + impostor[0] + "\nSaving to " + savePath);
                File.saveContent(savePath, haxe.Json.stringify(shitToSave, semen));
            }
        }
    }
}