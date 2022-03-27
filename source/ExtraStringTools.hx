package;

import haxe.iterators.StringIterator;
import haxe.iterators.StringKeyValueIterator;

#if cpp
using cpp.NativeString;
#end

class ExtraStringTools {
    public static inline function displayPathNatively(s:String):String {
        #if windows
        return s.split('/').join('\\');
        #else
        return s.split('\\'.join('/');
        #end
    }
}