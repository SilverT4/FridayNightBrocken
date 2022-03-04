package random.oc;
/**Pronoun set!

    Personal is usually something like he, she, they

    Objective is usually something like him, her, them

    Determiner is usually something like his, her, their

    Posessive is usually something like his, hers, theirs

    Reflexive is usually something like himself, herself, themself
    
    @param example they/them/their/theirs/themself*/
typedef Pronoun = {
    var personal:String;
    var objective:String;
    var determiner:String;
    var posessive:String;
    var reflexive:String;
}