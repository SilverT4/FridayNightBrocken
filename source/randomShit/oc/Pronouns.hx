package randomShit.oc;
import randomShit.oc.DevinsCharacterList.OCThing;
import MusicBeatSubstate;
import randomShit.dumb.FunnyReferences;
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