package randomShit.oc;

import flixel.util.FlxColor;
import randomShit.oc.DevinsCharacterList;
import flixel.group.FlxGroup;
import randomShit.oc.Pronouns;
import randomShit.oc.CharacterFavourites;
import flixel.addons.ui.FlxUIColorSwatchSelecter;
import DialogueBoxPsych;
import randomShit.util.DevinsFileUtils;

using StringTools;

/**Custom typedef for the dialogue tab. Also used in my fileutils
@since March 2022 (Emo Engine 0.1.1)*/
typedef OCDiaThingy = {
    var FilePath:String;
    var FileContent:DialogueFile;
    var DiaLines:Int;
}
/**OC Editor state. I'm hoping to have this be better looking in some way than the original!
    @since (currently in testing)*/
class OCEditorState extends MusicBeatState {
    var ExampleCharacter:String = '{
        "dialogueFileName": "blitz",
        "characterNames": [
            "Blitz",
            "blitz"
        ],
        "characterBirthday": [
            12,
            4,
            2004
        ],
        "characterHeight": [
            7,
            1
        ],
        "characterSpecies": "Were-con",
        "characterImage": "blitzPicture",
        "favouriteColours": [
            "blue",
            "purple"
        ],
        "favouriteAesthetics": [
            "simple"
        ],
        "favouriteGames": [
            "Luigi\'s Mansion",
            "Minecraft"
        ],
        "favouriteMusicGenres": [
            "chillwave"
        ],
        "favouriteArtists": [
            "Crystal Castles",
            "Pogo"
        ],
        "menuBgColor": 0
    }'; // INCOMPLETE SINCE I DON'T KNOW HOW JSONS HANDLE FLXCOLOURS OR CUSTOM TYPEDEFS!!
    var CharacterPreview:Character;
    var ImagePreview:FlxSprite;
    var Main_UI_Box:FlxUITabMenu;
    var Main_UI_Elements_Act:FlxUI; // Actions UI.
    var Main_UI_Elements_Bas:FlxUI; // The basics.
    var Main_UI_Elements_Fav:FlxUI; // Favourites
    var Main_UI_Elements_Pro:FlxUI; // Pronouns
    var Main_UI_Elements_Dia:FlxUI; // Dialogue list for the interactions menu. Will include a button to take you to dialogue editor.
    var Menu_Background:FlxSprite;
    var ExamplePronouns:String = '{
        "personal": "they",
        "objective": "them",
        "determiner": "their",
        "posessive": "theirs",
        "reflexive": "themself"
    }'; // I'm using the same thing as in the old Pronoun Editor
    var TheBitch:OCThing;
    var MenuBgColor:FlxColor;

    public function new(?chara:String) {
        super();
        if (chara != null) {
            // SETS UP THE CHARACTER AHEAD OF TIME!
            loadThisBitch(chara);
        } else {
            // SETS UP THE CHARACTER AHEAD OF TIME!
            createTheBitch();
        }
        if (!FlxG.mouse.visible) FlxG.mouse.visible = true;
    }

    inline function loadThisBitch(chara:String) {
        trace('LETS LOAD A BITCH LMAO');
        TheBitch = DevinsFileUtils.ocInfo(chara);
        /*if (TheBitch.menuBgColor != null) {
            MenuBgColor = TheBitch.menuBgColor;
        } */
        trace('WE AINT SETTIN UP PRONOUNS HERE YET, I NEED TO WORK ON THAT!');
    }

    inline function createTheBitch() {
        trace('SETTING UP A NEW BITCH!!');
        parseExample(0);
        parseExample(1);
        trace(TheBitch);
    }

    inline function parseExample(ExampleToParse:Int) {
        var bruhMoment:Dynamic;
        switch (ExampleToParse) {
            case 0: // OC BASICS, I'LL INCLUDE PRONOUNS IN A WHILE
                bruhMoment = cast Json.parse(ExampleCharacter);
                TheBitch = bruhMoment;
                TheBitch.characterPronouns = [];
                /*if (TheBitch.menuBgColor != null) {
                    MenuBgColor = TheBitch.menuBgColor;
                } */
            case 1: // I'M MOVING THIS INTO THE OC BASICS LATER.
                bruhMoment = cast Json.parse(ExamplePronouns);
                TheBitch.characterPronouns.push(bruhMoment);
        }
    }

    override function create() {
        Menu_Background = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        Menu_Background.setGraphicSize(Std.int(Menu_Background.width * 1.1));
        Menu_Background.scrollFactor.set();
        Menu_Background.screenCenter();
        Menu_Background.updateHitbox();
        add(Menu_Background);

        var tabs = [
            { name: 'Actions', label: 'Actions' },
            { name: 'Basics', label: 'Basics' },
            { name: 'Favourites', label: 'Favourites' },
            { name: 'Pronouns', label: 'Pronouns' },
            { name: 'Dialogue', label: 'Dialogue' }, // maybe i'll move OC interaction dialogues to their own editor later on. idk
            { name: 'Preview', label: 'Preview' } // so i can preview this shit. idk
        ];
        Main_UI_Box = new FlxUITabMenu(null, tabs);
        Main_UI_Box.resize(500, 350);
        Main_UI_Box.x = FlxG.width - 525;
        Main_UI_Box.y = FlxG.height * 0.11;
        add(Main_UI_Box);
        setupActionUI();
        /*setupBasicsUI();
        setupFavesUI();
        setupPronUI();
        setupDialUI();
        setupPrevUI(); */
    }

    function setupActionUI() {
        Main_UI_Elements_Act = new FlxUI(null, Main_UI_Box);
        Main_UI_Elements_Act.name = 'Actions';

        var saveButton:FlxButton = new FlxButton(20, 40, 'Save Character', beginSave);

        var resetButton:FlxButton = new FlxButton(20, 80, 'Reset Character', resetChar);

        var exitButton:FlxButton = new FlxButton(20, 120, 'Exit to Editors', function() {
            openSubState(new CheckYourWorkMate());
        });

        Main_UI_Elements_Act.add(exitButton);
        Main_UI_Box.addGroup(Main_UI_Elements_Act);
    }

    inline function beginSave() {
        trace('ass');
    }
    
    inline function resetChar() {
        trace('penis');
    }
    var workPossiblyUnsaved:Bool = true;
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK && workPossiblyUnsaved) {
            openSubState(new CheckYourWorkMate());
        }
    }
}

/**REMINDER TO CHECK THAT YOU'VE SAVED LMAO
    @since March 2022 (Emo Engine 0.1.1)*/
class CheckYourWorkMate extends MusicBeatSubstate {
    var warnSound:FlxSound;
    var warnBg:FlxSprite;
    var warnText:FlxText;

    public function new() {
        super();
    }

    override function create() {
        warnBg = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(warnBg);
        warnSound = new FlxSound();
        warnSound.loadEmbedded(Paths.sound('warning'));
        warnText = new FlxText(0, 0, FlxG.width, "HOLD ON!!\n\nDid you save your work? Exiting this editor without saving WILL NOT autosave your character, so you'll have to start from scratch.\n\nPress ENTER to continue or ESCAPE to return to the editor and save.", 48);
        warnText.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        warnText.screenCenter();
        add(warnText);
        warnSound.play();
    }

    override function update(elapsed:Float) {
        if (controls.ACCEPT) {
            FlxG.sound.play(Paths.sound('confirmMenu'), 1, false, null, true, function() {
                MusicBeatState.switchState(new editors.MasterEditorMenu());
            });
        }

        if (controls.BACK) {
            close();
        }
    }
}