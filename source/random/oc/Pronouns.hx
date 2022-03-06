package random.oc;
import random.oc.DevinsCharacterList.OCThing;
import MusicBeatSubstate;
import random.dumb.FunnyReferences;
/**Pronoun set!

    Personal is usually something like he, she, they

    Objective is usually something like him, her, them

    Determiner is usually something like his, her, their

    Posessive is usually something like his, hers, theirs

    Reflexive is usually something like himself, herself, themself
    
    @param example they/them/their/theirs/themself
    @since March 2022 (Emo Engine 0.1.1)*/
typedef Pronoun = {
    var personal:String;
    var objective:String;
    var determiner:String;
    var posessive:String;
    var reflexive:String;
}
/**This typedef can be used to tell the game to display an example sentence based on whether the pronoun set is a singular or plural pronoun.
    @since March 2022 (Emo Engine 0.1.1)*/
typedef PronounCase = {
    var singular:Bool;
    var plural:Bool;
}

/**This'll be used soon in place of the current Editor substate included in the DevinsCharacterList.hx file.
    (I gotta have it extend MusicBeatSubstate if I want it to actually be openable.)
    @since (Unused)
    @unused shit*/
class PronounManager extends MusicBeatSubstate {
    static final examplePronouns:String = '{
        "personal": "they",
        "objective": "them",
        "determiner": "their",
        "posessive": "theirs",
        "reflexive": "themself"
    }'; // This is a placeholder. I use they/them as it's the most gender-neutral, at least in the English language. I don't know about other languages, really...
    static var hisDick:SmallerThanMyToes;
    var UI_EXIST:FlxUITabMenu;
    var UI_MOD:FlxUITabMenu;
    var bussyList:FlxUIDropDownMenuCustom;
    var penisSauce:Pronoun;
    static var CPR:Array<Pronoun>;
    public static var squidwardNose:Array<String> = [];

    public function new(?input:Array<Pronoun>) {
        super();
        if (input != null) {
            CPR = input;
        }
        if (penisSauce == null) {
            if (input != null) {
                penisSauce = input[0];
            } else {
                penisSauce = cast Json.parse(examplePronouns);
                CPR = [penisSauce];
            }
        }
    }

    /**This function will allow you to add the personal pronouns in each pronoun set of your character to the list generated when the substate is opened. I recommend using this!
        (I might set this to be automatically used JUST in case. lol)
    @since (Currently unused.)*/
    public static function addPrnsToList(prns:Array<Pronoun>) {
        trace('adding Pronouns!');

        for (i in 0...prns.length) {
            if (!squidwardNose.contains(prns[i].personal)) {
            trace('now adding this one: ' + prns[i].personal);
            squidwardNose.push(prns[i].personal);
            } else {
                FlxG.log.warn('Ayo what are you doing dumbass?! This shit already exists in the list: ' + prns[i].personal);
                trace('Ayo what are you doing dumbass?! This shit already exists in the list: ' + prns[i].personal);
            }
        }
    }
    /**Generates an example sentence. Useful for something like an FlxText.
        @param prns The pronoun set to use.
        @param cl Whether the pronoun set is singular or plural
        @param char This just helps to personalise it to the character.*/
    public static function exampleSentence(prns:Pronoun, cl:PronounCase, char:OCThing):String {
        if (cl.singular) {
            return "So I met a " + char.characterSpecies + " today. " + convertToProperCase(prns.determiner) + " name was " + char.characterNames[0] + ". " + convertToProperCase(prns.personal) + " goes by " + prns.personal + "/" + prns.objective + " pronouns. " + convertToProperCase(prns.personal) + " talked a lot about the hobbies of " + prns.posessive + ". It sounded like " + prns.personal + " keeps " + prns.reflexive + " busy! Maybe next time I meet up with " + prns.objective + ", I can ask if " + prns.personal + " would be interested in meeting you guys!";
        } else {
            return "Sometimes I think about that new friend I made the other day. I never did get " + prns.determiner + " phone number or anything, I just know " + prns.determiner + " name is " + char.characterNames[0] + " and " + prns.personal + " go by " + prns.personal + "/" + prns.objective + " pronouns. An interesting " + char.characterSpecies + " for sure! If I see " + prns.objective + " again, I'll be asking about the phone number and any hobbies of " + prns.posessive + ". Or maybe " + prns.personal + " might find me on social media and reach out " + prns.reflexive + "! Who knows? Either way, I thought " + prns.personal + " were pretty cool.";
        }
    }

    static inline function convertToProperCase(prn:String):String {
        return prn.charAt(0).toUpperCase() + prn.substr(1, prn.length);
    }
    var phColours:Array<Int> = [0x69000000, 0x69f7971d];
    override function create() {
        var pornHub:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, phColours[0]);
        pornHub.scrollFactor.set();
        add(pornHub);
        var hubPorn:FlxSprite = new FlxSprite(FlxG.width * 0.5, 100).makeGraphic(Std.int(FlxG.width / 2), FlxG.height - 200, phColours[1]);
        hubPorn.scrollFactor.set();
        add(hubPorn);

        var tabs = [
            {name: 'Select', label: 'Existing'}
        ];
        UI_EXIST = new FlxUITabMenu(null, null, tabs);
        UI_EXIST.resize(250, 120);
		UI_EXIST.x = FlxG.width - 275;
		UI_EXIST.y = 25;
        UI_EXIST.scrollFactor.set();
        add(UI_EXIST);
    }
    var allBoxesLoaded:Bool = false;
    inline function setupExistUI() {
        var tabussy = new FlxUI(null, UI_EXIST); //HHH
        tabussy.name = 'Select';

        bussyList = new FlxUIDropDownMenuCustom(10, 30, FlxUIDropDownMenuCustom.makeStrIdLabelArray([''], true), function(pronoun:String) {
            if (bussyList.selectedLabel != null) {
                penisSauce = CPR[squidwardNose.indexOf(bussyList.selectedLabel)];
            }
            if (allBoxesLoaded) reloadPronounBoxes();
            reloadTheBussy();
        });
        bussyList.selectedLabel = penisSauce.personal;
        reloadTheBussy();

        tabussy.add(new FlxText(bussyList.x, bussyList.y - 18, 0, 'Select a pronoun set:'));
        tabussy.add(bussyList);
        UI_EXIST.addGroup(tabussy);
    }

    inline function reloadTheBussy() {
        squidwardNose = [];
        for (i in 0...CPR.length) {
            squidwardNose.push(CPR[i].personal);
        }
        bussyList.setData(FlxUIDropDownMenuCustom.makeStrIdLabelArray(squidwardNose, true));
    }
    var personalBox:FlxUIInputText;
    var objectiveBox:FlxUIInputText;
    var determinerBox:FlxUIInputText;
    var posessiveBox:FlxUIInputText;
    var reflexiveBox:FlxUIInputText;
    inline function reloadPronounBoxes() {
        if (personalBox != null) {
            personalBox.text = penisSauce.personal;
        }
        if (objectiveBox != null) {
            objectiveBox.text = penisSauce.objective;
        }
        if (determinerBox != null) {
            determinerBox.text = penisSauce.determiner;
        }
        if (posessiveBox != null) {
            posessiveBox.text = penisSauce.posessive;
        }
        if (reflexiveBox != null) {
            reflexiveBox.text = penisSauce.reflexive;
        }
    }
}