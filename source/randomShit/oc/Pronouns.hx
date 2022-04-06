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

/**This enum replaces PronounCase, although I dunno *why* exactly I'm updating this shit considering I'm working on a separate project that'll be more focused on showing information about my OCs.
    @since April 2022 (Emo Engine 0.2.0)*/
enum CasePronoun {
    /**Singular pronouns (such as he, she, it).*/SINGULAR; /**Plural pronouns (such as they, we).*/PLURAL;
}