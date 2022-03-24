package randomShit.util;

import haxe.Exception;
using StringTools;

/**Custom exception maybe.
    @since March 2022 (Emo Engine 0.1.2)*/
class ProfileException extends Exception {
    public function new(ErrorMessage:Dynamic) {
        super(Std.string(ErrorMessage));
    }
}