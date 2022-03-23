package randomShit.oc;

import randomShit.oc.old.OLD_DCLEditorState;
import randomShit.util.CheckinMultiple.OOMOTIS;
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
import randomShit.oc.Pronouns.Pronoun;
import randomShit.oc.old.*;
import flixel.util.FlxColor;
import haxe.Json;
import randomShit.oc.CharacterFavourites;

using StringTools;
/**A typedef to help display things on screen. Uses Strings, Ints, and my custom Pronoun type.
    
@param dialogueFileName The dialogue json file name. It's *usually* the same as the character's name that you'd select in the chart editor.
@param characterNames An array of names. You can set their *real* name alongside the name used to select them in the chart editor.
@param characterPronouns The pronouns your character uses. This is an array to provide more than one set if necessary.
@param chPronStrings The PERSONAL pronouns of your character's pronouns as an array of strings. Example: he/they/it/techne (he/him, they/them, it/its, tech/techne)
@param characterBirthday The character's birthday as an int array. Format will be displayed as DD/MM/YYYY.
@param characterHeight An int array of the character's height in ft. Example: 5'3"
@param characterFavourites A custom typedef is going to be set up for this. It'll be a bit less... Bulky? I guess? Than the current setup below.
@param favouriteColours An array of the character's favourite colours. **WILL BE MOVED TO A TYPEDEF** (Ditto for aesthetics, genres, artists, games)
@param menuBgColor Allows you to set a custom FlxColor when you look at this character from the character list.
@since March 2022 (Emo Engine 0.1.1)*/
typedef OCThing = {
    var dialogueFileName:String; // USUALLY JUST THE SAME AS THE CHARACTER NAME.
    var characterNames:Array<String>; // Includes their ACTUAL name and the name used in game to load their json!
    var characterPronouns:Array<Pronoun>; // This is an array to allow for multiple sets of pronouns! If you have more than one set for a character, you can choose to display them all separately or in one set that uses each *personal/subjective* pronoun!
    var chPronStrings:Array<String>; // THIS IS AUTOMATICALLY UPDATED AS YOU ADD/REMOVE PRONOUNS.
    var characterBirthday:Array<Int>; // Character birthday. Format is DD/MM/YYYY.
    var characterHeight:Array<Int>; // Height in ft.
    var characterSpecies:String; // Are they human, Mini-con, etc.?
    var characterImage:String; // If you want to include an image, place it in assets/images/myOCs!
    var favouriteColours:Array<String>; // For if a character's got some favourite colours
    var favouriteAesthetics:Array<String>; // Ditto, but for aesthetics (like grunge, neon, etc.)
    var favouriteGames:Array<String>; // Ditto, but for games
    var favouriteMusicGenres:Array<String>; // Ditto, but for genres of music.
    var favouriteArtists:Array<String>; // Ditto, but for artists
    var characterFavourites:CharFavourites; // THIS IS HERE AS A REPLACEMENT FOR THE ABOVE FAVOURITE VARIABLES. THOSE'LL BE KEPT AROUND TO ALLOW YOU TO MOVE THEM OVER.
    var menuBgColor:FlxColor;
}

/**This typedef will allow you to convert your character's favourite arrays into a custom typedef variable. It'll be available in the Favourites tab after everything is set up.
    @deprecated Deprecated by CharFavourites, defined in **[CharacterFavourites](/source/random/oc/CharacterFavourites.hx)**. This is a legacy typedef to allow for converting older JSONs to ones compatible with the new style.
    @since March 2022 (Emo Engine 0.1.1)*/
typedef OCThing_Old = {
    var favouriteColours:Array<String>;
    var favouriteAesthetics:Array<String>;
    var favouriteGames:Array<String>;
    var favouriteMusicGenres:Array<String>;
    var favouriteArtists:Array<String>;
}

/**idk just to show my ocs*/
class DevinsCharacterList extends MusicBeatState {
    
}

/**separate thing for pronoun editing
@deprecated ...Or, at least, this will be. I'm planning to include this substate in the **Pronouns** hx file.*/
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