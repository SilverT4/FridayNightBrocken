package random.util;

import random.oc.Pronouns;
using StringTools;

class CheckinMultiple {
    var fuckyou:Pronoun;
}
/**This allows you to check multiple things for a specific value. If a match is found in any of the things you check, returns true. If not, returns false.
    OOTIS stands for One Of These Is True*/
class OOTIS {
    static var justthefax:Array<Dynamic>;
    static var foundmatch:Bool = false;
    /**Check if one or more individual items contains a certain value.
    @param Things The things to check. Types can be different, as long as they're compatible with each other.
    @param Value What we're looking for.
    @since March 2022 (Emo Engine v0.1.1)*/
    public static function check(Things:Array<Dynamic>, Value:Dynamic):Bool {
        justthefax = Things;
        for (i in 0...justthefax.length) {
            if (justthefax[i] == Value) {
                foundmatch = true;
                return true;
                break;
            } else {
                continue;
            }
        }
        return foundmatch;
    }
    /**Allows you to check an array to see whether it **does** or **does not** contain a certain value.
        
    @param WeCheck The array to check. Type does not matter.
    @param WeWant What are we looking for? Type does not matter.
    @param CheckType Are we looking to see if the array *does* or *does not* contain the value? Options are "Contains" for if it does, "DoesNotContain" for if it does not.
    @since March 2022 (Emo Engine v0.1.1)*/
    public static function checkArray(WeCheck:Array<Dynamic>, WeWant:Dynamic, CheckType:Dynamic):Bool {
        justthefax = WeCheck;
        switch (CheckType) {
            case 'Contains':
                if (justthefax.contains(WeWant)) {
                    foundmatch = true;
                    return true;
                }
            case 'DoesNotContain':
                if (!justthefax.contains(WeWant)) {
                    foundmatch = true;
                    return true;
                }
        }
        return foundmatch;
    }
}
/**Allows you to check for multiple things being true.
    OOMOTIS is just "One Or More Of These Is True"
    @since March 2022 (Emo Engine v0.1.1)*/
class OOMOTIS {
    static var sexyCount:Int = 0;
    static var bussysharts:Array<Dynamic>;
    static var foundallmatches:Bool = true;
    /**Check if multiple things have a specific value. You can specify how many things out of the list need to be true in order for the whole statement to be true.
        
    @param Things Things to check. These can be of different types as long as they're compatible in some form.
    @param Value What we're looking for.
    @param OfList Int. How many are we looking to see as true?
    @since March 2022 (Emo Engine v0.1.1)*/
    public static function check(Things:Array<Dynamic>, Value:Dynamic, OfList:Int):Bool {
        bussysharts = Things;
        for (i in 0...bussysharts.length) {
            if (bussysharts[i] == Value) {
                sexyCount += 1;
                continue;
            } else {
                continue;
            }
            if (sexyCount == OfList) {
                foundallmatches = true;
                return true;
                break;
            } else {
                continue;
            }
            if (i == bussysharts.length && !foundallmatches) {
                return false;
            }
        }
        return foundallmatches;
    }
    /**Checks for nulls in multiple variables. A function on complete is *recommended*.
    @param Things What are we checking nulls in?
    @param OfList How many should (NOT) be null?
    @param expected What's the expected return result?
    @param onComplete Provide a function to run if OfList is met.
    @param onError If OfList is not met, run this code.
    @param WeWant Do we want it TO be null or NOT to be null?
    @since March 2022 (Emo Engine 0.1.1)*/
    public static function checkForNulls(Things:Array<Dynamic>, OfList:Int, expected:Dynamic, onComplete:Dynamic -> Void, onError:Dynamic -> Void, WeWant:Bool):Dynamic {
        bussysharts = Things;
        var actualResult:Bool = false;
        for (i in 0...bussysharts.length) {
            if (bussysharts[i] == WeWant) {
                sexyCount += 1;
                continue;
                //return 'bussy';
            } else if (i == bussysharts.length || sexyCount == OfList) {
                actualResult = true;
                onComplete(expected);
            } else if (i == bussysharts.length && sexyCount < OfList) {
                onError(expected);
            }
        }
        return actualResult;
        //return 'penis';
    }
}