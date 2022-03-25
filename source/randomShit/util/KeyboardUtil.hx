package randomShit.util;

import flixel.input.keyboard.FlxKey;

using StringTools;

/**A small class that can get the *names* of an FlxKey. Mostly made this because I'm too dumb and lazy to figure it out with the flixel shit.
    @since March 2022 (Emo Engine 0.1.2)*/
class KeyboardUtil {
    static var KeyStrings:Map<FlxKey, String> = [
        ANY => "Any",
        NONE => "None",
        A => "A",
        B => "B",
        C => "C",
        D => "D",
        E => "E",
        F => "F",
        G => "G",
        H => "H",
        I => "I",
        J => "J",
        K => "K",
        L => "L",
        M => "M",
        N => "N",
        O => "O",
        P => "P",
        Q => "Q",
        R => "R",
        S => "S",
        T => "T",
        U => "U",
        V => "V",
        W => "W",
        X => "X",
        Y => "Y",
        Z => "Z",
        ZERO => "0",
        ONE => "1",
        TWO => "2",
        THREE => "3",
        FOUR => "4",
        FIVE => "5",
        SIX => "6",
        SEVEN => "7",
        EIGHT => "8",
        NINE => "9",
        NUMPADZERO => "0",
        NUMPADONE => "1",
        NUMPADTWO => "2",
        NUMPADTHREE => "3",
        NUMPADFOUR => "4",
        NUMPADFIVE => "5",
        NUMPADSIX => "6",
        NUMPADSEVEN => "7",
        NUMPADEIGHT => "8",
        NUMPADNINE => "9",
        MINUS => "-",
        PLUS => "+",
        PAGEUP => "Page Up",
        PAGEDOWN => "Page Down",
        END => "End",
        HOME => "Home",
        INSERT => "Insert",
        ESCAPE => "Esc",
        DELETE => "Del",
        BACKSPACE => "Backspace",
        LBRACKET => "[",
        RBRACKET => "]",
        BACKSLASH => "\\",
        CAPSLOCK => "Caps Lock",
        SEMICOLON => ";",
        QUOTE => "'",
        ENTER => #if windows "ENTER", #else "Return", #end
        SHIFT => "Shift",
        COMMA => ",",
        PERIOD => ".",
        GRAVEACCENT => "`",
        CONTROL => "Ctrl",
        ALT => #if macos "Option", #else "Alt", #end
        SPACE => "Spacebar",
        UP => "Up",
        DOWN => "Down",
        LEFT => "Left",
        RIGHT => "Right",
        TAB => "Tab",
        PRINTSCREEN => "Print Screen",
        F1 => "F1",
        F2 => "F2",
        F3 => "F3",
        F4 => "F4",
        F5 => "F5",
        F6 => "F6",
        F7 => "F7",
        F8 => "F8",
        F9 => "F9",
        F10 => "F10",
        F11 => "F11",
        F12 => "F12",
        NUMPADMULTIPLY => "Numpad *",
        NUMPADPERIOD => "Numpad .",
        NUMPADPLUS => "Numpad +",
        NUMPADMINUS => "Numpad -",
        SLASH => "/"
    ];

    public static function getKeyNames(Keys:Array<FlxKey>) {
        var keything = Keys;
        var retthing:Array<String> = [];
        for (key in keything) {
            retthing.push(KeyStrings[key]);
        }
        return retthing.join(', ');
    }
}