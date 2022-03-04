package random.util;

import random.oc.Pronouns;
using StringTools;

class CheckinMultiple {
    var fuckyou:Pronoun;
}
/**This allows you to check multiple things. If one is true, returns true. If not, returns false.
    OOTIS stands for One Of These Is True*/
class OOTIS {
    static var justthefax:Array<Dynamic>;
    static var foundmatch:Bool = false;
    public static function check(Things:Array<Dynamic>, Value:Dynamic):Bool {
        justthefax = Things;
        for (i in 0...justthefax.length) {
            if (justthefax[0] == Value) {
                foundmatch = true;
                return true;
                break;
            } else {
                continue;
            }
        }
        return foundmatch;
    }
}
/**Allows you to check for multiple things being true.
    OOMOTIS is just "One Or More Of These Is True"*/
class OOMOTIS {
    static var sexyCount:Int = 0;
    static var bussysharts:Array<Dynamic>;
    static var foundallmatches:Bool = true;
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
}