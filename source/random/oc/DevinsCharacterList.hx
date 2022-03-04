package random.oc;

import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.system.FlxSound;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUI;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import FlxUIDropDownMenuCustom;
import MusicBeatState;
import MusicBeatSubstate;
import random.oc.Pronouns.Pronoun;
import flixel.util.FlxColor;
import haxe.Json;

using StringTools;

typedef OCThing = {
    var dialogueFileName:String; // USUALLY JUST THE SAME AS THE CHARACTER NAME.
    var characterNames:Array<String>; // Includes their ACTUAL name and the name used in game to load their json!
    var characterPronouns:Array<Pronoun>; // This is an array to allow for multiple sets of pronouns! If you have more than one set for a character, you can choose to display them all separately or in one set that uses each *personal/subjective* pronoun!
    var characterBirthday:Array<Int>; // Character birthday. Format is DD/MM/YYYY.
    var characterHeight:Array<Int>; // Height in ft.
    var characterSpecies:String; // Are they human, Mini-con, etc.?
    var characterImage:String; // If you want to include an image, place it in assets/images/myOCs!
    var favouriteColours:Array<String>; // For if a character's got some favourite colours
    var favouriteAesthetics:Array<String>; // Ditto, but for aesthetics (like grunge, neon, etc.)
    var favouriteGames:Array<String>; // Ditto, but for games
    var favouriteMusicGenres:Array<String>; // Ditto, but for genres of music.
    var favouriteArtists:Array<String>; // Ditto, but for artists
    var menuBgColor:FlxColor;
}

/**idk just to show my ocs*/
class DevinsCharacterList extends MusicBeatState {
    
}

/**editor state thing*/
class DCLEditorState extends MusicBeatState {
    var exampleCharacter:String = '{
        "dialogueFileName": "bf",
        "characterNames": [
            "Devin",
            "bf"
        ],
        "characterBirthday": [
            18,
            11,
            2002
        ],
        "characterHeight": [
            5,
            6
        ],
        "characterSpecies": "Human",
        "characterImage": "pogIcon",
        "favouriteColours": [
            "cyan",
            "a VERY specific shade of green"
        ],
        "favouriteAesthetics": [
            "grunge",
            "weirdcore",
            "liminal"
        ],
        "favouriteGames": [
            "Animal Crossing",
            "FNF",
            "Mario Kart",
            "Roblox",
            "Minecraft"
        ],
        "favouriteMusicGenres": [
            "pop",
            "lofi",
            "rock"
        ],
        "favouriteArtist": [
            "Panic! at the Disco",
            "atsuover",
            "CupcakKe",
            "ElyOtto",
            "Bo Burnham",
            "Jason Derulo"
        ]
    }'; // yes this is ME in the example! - devin503
    var examplePronouns:String = '{
        "personal": "they",
        "objective": "them",
        "determiner": "their",
        "posessive": "theirs",
        "reflexive": "themself"
    }';
    var pronoun:Pronoun;
    public static var OC:OCThing;
    var characterSetupBox:FlxUITabMenu;
    var realCharaNameBox:FlxUIInputText;
    var gameCharaNameBox:FlxUIInputText;
    var pronounList:FlxText;
    var pronounEditButton:FlxButton;
    var bdayBoxes:Array<FlxUIInputText> = [];
    var heightBoxes:Array<FlxUIInputText> = [];
    var speciesBox:FlxUIInputText;
    var imageBox:FlxUIInputText;
    var favouriteBoxes:Array<FlxUIInputText> = [];
    var bg:FlxSprite;
    var inputtedName:String;

    public function new(?character:String = 'snowdrift') {
        super();
        if (!FlxG.mouse.visible) {
            FlxG.mouse.visible = true;
            FlxG.mouse.useSystemCursor = true;
        }
        if (character != null) {
            doFileCheck(character);
        }
    }
    /**Checks the OC folder to see if a file already exists for the character input in the editor menu.
        If one exists, OC will be set to that. Otherwise, the character input will be set to the **second** value in characterNames*/
    static inline function doFileCheck(input:String) {

    }
    override function create() {
        if (OC == null) {
            OC = cast haxe.Json.parse(exampleCharacter);
            if (inputtedName != null) {
                OC.characterNames.pop();
                OC.characterNames.push(inputtedName);
            }
            pronoun = cast Json.parse(examplePronouns);
            OC.characterPronouns = [pronoun];
            trace(OC);
        }
        bg = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.screenCenter();
        bg.color = 0xFFA6D388;
        add(bg);
        var tabs = [
            {name: 'Basics', label: 'Basics'},
            {name: 'Pronouns', label: 'Pronouns'},
            {name: 'Favourites', label: 'Favourites'}
        ];
        characterSetupBox = new FlxUITabMenu(null, tabs);
        characterSetupBox.resize(420, 500);
        characterSetupBox.x = FlxG.width - 420;
        add(characterSetupBox);
        generateUIBasics();
        generateUIPronouns();
        generateUIFavourites();
    }
    function generateUIBasics() {
        var tab_group = new FlxUI(null, characterSetupBox);
        tab_group.name = 'Basics';

        realCharaNameBox = new FlxUIInputText(10, 40, 200, OC.characterNames[0], 8); // if this doesn't show up correctly i'm gonna be including a note on open of the editor to let the player know
        gameCharaNameBox = new FlxUIInputText(10, realCharaNameBox.y - 30, 200, OC.characterNames[1], 8);

        var bdayDateBox:FlxUIInputText = new FlxUIInputText(10, gameCharaNameBox.y - 30, 50, OC.characterBirthday[0], 8);
        var bdayMonthBox:FlxUIInputText = new FlxUIInputText(bdayDateBox.x + 60, bdayDateBox.y, 50, OC.characterBirthday[1], 8);
        var bdayYearBox:FlxUIInputText = new FlxUIInputText(bdayMonthBox.x + 60, bdayDateBox.y, 50, OC.characterBirthday[2], 8);

        bdayBoxes.push(bdayDateBox);
        bdayBoxes.push(bdayMonthBox);
        bdayBoxes.push(bdayYearBox);
        trace(bdayBoxes.length);
        tab_group.add(new FlxText(10, realCharaNameBox.y - 18, 0, 'Character\'s real name', 8));
        tab_group.add(new FlxText(10, gameCharaNameBox.y - 18, 0, 'Character\'s game char. name', 8));
        tab_group.add(new FlxText(10, bdayDateBox.y - 18, 0, 'Character\'s birthday (DD/MM/YYYY)', 8));
        characterSetupBox.addGroup(tab_group);
    }
    function generateUIPronouns() {
        var tab_group = new FlxUI(null, characterSetupBox);
        tab_group.name = 'Pronouns';

        pronounList = new FlxText(10, 25, 410, OC.characterPronouns.toString(), 16);
        pronounEditButton = new FlxButton(240, 480, 'Edit', function() {
            trace('opening substate');
            openSubState(new PronounEditorSubstate());
        });
        

        tab_group.add(pronounList);
        tab_group.add(pronounEditButton);
        characterSetupBox.addGroup(tab_group);
    }
    public static var bruj:DCLEditorState;
    function generateUIFavourites() {
        var tab_group = new FlxUI(null, characterSetupBox);
        tab_group.name = 'Favourites';

        var favouriteColoursBox = new FlxUIInputText(10, 40, 200, OC.favouriteColours.toString(), 8);
        favouriteBoxes.push(favouriteColoursBox);

        tab_group.add(new FlxText(10, favouriteColoursBox.y - 18, 0, 'Favourite colour(s):'));
        tab_group.add(favouriteColoursBox);
        characterSetupBox.addGroup(tab_group);
    }
}

/**separate thing for pronoun editing*/
class PronounEditorSubstate extends FlxSubState {
    var transBg:FlxSprite;
    var existingListBox:FlxUITabMenu;
    var modificationBox:FlxUITabMenu;
    var susnoun:Pronoun;
    var existingPronouns:Array<String> = [];
    static var OC:OCThing;
    public function new() {
        super();
        OC = DCLEditorState.OC;
        for (i in 0...OC.characterPronouns.length) {
            existingPronouns.push(OC.characterPronouns[i].personal);
            trace(existingPronouns);
        }
        trace(OC);
    }

    override function create() {
        transBg = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 0, 0, 128));
        add(transBg);
        var tabs = [
            {name: 'Pronoun List', label: 'Pronoun List'}
        ];
        existingListBox = new FlxUITabMenu(null, tabs);
        existingListBox.resize(200, 200);
        existingListBox.x = FlxG.width - 200;
        add(existingListBox);
        setupExistingList();
        var tabs = [
            {name: 'Modify', label: 'Modify'}
        ];
        modificationBox = new FlxUITabMenu(null, tabs);
        modificationBox.resize(250, 400);
        modificationBox.x = FlxG.width - 250;
        modificationBox.y += 200;
        add(modificationBox);
        setupModificationUI();
    }
    var pronounListDrop:FlxUIDropDownMenuCustom;
    function setupExistingList() {
        var tab_group = new FlxUI(null, existingListBox);
        tab_group.name = 'Pronoun List';

        pronounListDrop = new FlxUIDropDownMenuCustom(10, 20, FlxUIDropDownMenuCustom.makeStrIdLabelArray(existingPronouns, true), function(pronoun:String) {
            trace('amogus');
        });
        pronounListDrop.selectedLabel = existingPronouns[0];

        tab_group.add(new FlxText(10, pronounListDrop.y - 18, 0, 'Switch selection', 8));
        existingListBox.addGroup(tab_group);
    }
    function setupModificationUI() {
        var tab_group = new FlxUI(null, modificationBox);
        tab_group.name = 'Modify';

        var personalBox:FlxUIInputText = new FlxUIInputText(10, 40, 200, susnoun.personal, 8);
        var objectiveBox:FlxUIInputText = new FlxUIInputText(10, personalBox.y + 30, 200, susnoun.objective, 8);
        var determinerBox:FlxUIInputText = new FlxUIInputText(10, objectiveBox.y + 30, 200, susnoun.determiner, 8);
        var posessiveBox:FlxUIInputText = new FlxUIInputText(10, determinerBox.y + 30, 200, susnoun.posessive, 8);
        var reflexiveBox:FlxUIInputText = new FlxUIInputText(10, posessiveBox.y + 30, 200, susnoun.reflexive, 8);

        tab_group.add(new FlxText(10, personalBox.y - 18, 0, 'Personal pronoun', 8));
        tab_group.add(new FlxText(10, objectiveBox.y - 18, 0, 'Objective pronoun', 8));
        tab_group.add(new FlxText(10, determinerBox.y - 18, 0, 'Posessive determiner', 8));
        tab_group.add(new FlxText(10, posessiveBox.y - 18, 0, 'Posessive pronoun', 8));
        tab_group.add(new FlxText(10, reflexiveBox.y - 18, 0, 'Reflexive pronoun', 8));
        tab_group.add(personalBox);
        tab_group.add(objectiveBox);
        tab_group.add(determinerBox);
        tab_group.add(posessiveBox);
        tab_group.add(reflexiveBox);
        modificationBox.addGroup(tab_group);
    }
}