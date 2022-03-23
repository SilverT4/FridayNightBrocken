package randomShit.oc.old;
import randomShit.oc.DevinsCharacterList;
import randomShit.oc.old.OLD_PronounManager;
import randomShit.oc.Pronouns;
import MusicBeatState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUI;
import flixel.ui.FlxButton;
import flixel.text.FlxText;

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
            randomShit.oc.old.OLD_PronounManager.PronounManager.addPrnsToList(OC.characterPronouns);
            openSubState(new randomShit.oc.old.OLD_PronounManager.PronounManager(OC.characterPronouns));
        });
        

        tab_group.add(pronounList);
        tab_group.add(pronounEditButton);
        characterSetupBox.addGroup(tab_group);
    }
    public static var bruj:DCLEditorState;
    function generateUIFavourites() {
        var tab_group = new FlxUI(null, characterSetupBox);
        tab_group.name = 'Favourites';

        /*var favouriteColoursBox = new FlxUIInputText(10, 40, 200, OC.favouriteColours.toString(), 8);
        favouriteBoxes.push(favouriteColoursBox);

        tab_group.add(new FlxText(10, favouriteColoursBox.y - 18, 0, 'Favourite colour(s):'));
        tab_group.add(favouriteColoursBox); */
        /*if (OC.characterFavourites == null) {
            OC.characterFavourites = CharaFavouriteManager.convertToNewFormat(OC.favouriteColours, OC.favouriteAesthetics, OC.favouriteGames, OC.favouriteMusicGenres, ['Panic! at the Disco', 'atsuover']);
        }
        if (OC != null && OC.characterFavourites != null) {
            var favouritesList:FlxText = new FlxText(10, 20, 0, 'Favourite colours:\n' + OC.characterFavourites.favouriteColours.toString() + '\n\nFavourite aesthetics:\n' + OC.characterFavourites.favouriteAesthetics.toString() + '\n\nFavourite games:\n' + OC.characterFavourites.favouriteGames.toString() + '\n\nFavourite music genres:\n' + OC.characterFavourites.favouriteMusicGenres.toString() + '\nFavourite artists:\n' + OC.characterFavourites.favouriteArtists.toString(), 8);
        favouritesList.scrollFactor.set();
        tab_group.add(favouritesList);
        } */
        characterSetupBox.addGroup(tab_group);
    }
}