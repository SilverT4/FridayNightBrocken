package;

//this class will likely contain BOTH menu states, idk
import flixel.FlxG;
import flixel.FlxSprite;
import MusicBeatState;
import Alphabet;
import AttachedSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
using StringTools;

class BasicCharSel extends MusicBeatState {
    var characterList:Array<Array<Dynamic>> = [["bf", "bf", "Boyfriend"], ["bf-car", "bf", "Boyfriend Week 4"], ["bf-christmas", "bf", "Fetive Boyfriend"], ["bf-pixel", "bf-pixel", "Pixel Boyfriend"]];
    var bg:FlxSprite;
    var grpChars:FlxTypedGroup<Alphabet>;
    private static var curSelected:Int = 0;
    var iconArray:Array<HealthIcon> = [];
    public function new() {
        super();

        if (PlayState.SONG != null) {
            characterList.insert(0, [PlayState.SONG.player1, getIcon(PlayState.SONG.player1), "Song Default"]);
        }
    }

    function getIcon(char:String) {
        var krab = Paths.fileExists(Paths.json('characters/$char.json'), TEXT);
        if (krab) {
            var boi = haxe.Json.parse(Paths.getTextFromFile('characters/$char.json')); // dynamic variables save the day lmao
            return boi.healthicon;
        }
        else return "face";
    }

    override function create() {
        trace("fuck");

        bg = new FlxSprite();
        bg.loadGraphic(Paths.image("menuDesat"));
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        add(bg);
        bg.screenCenter();

        grpChars = new FlxTypedGroup<Alphabet>();
        add(grpChars);

        for (bork in 0...characterList.length) {
            var bruh:Alphabet = new Alphabet(90, 320, characterList[bork][2], true);
            bruh.isMenuItem = true;
            bruh.targetY = bork - curSelected;
            grpChars.add(bruh);

            var maxWidth = 980;
            if (bruh.width > maxWidth)
                {
                    bruh.scaleX = maxWidth / bruh.width;
                }

            var icon:HealthIcon = new HealthIcon(characterList[bork][1]);
            icon.sprTracker = bruh;

            iconArray.push(icon);
            add(icon);
        }
        intendedColor = CoolUtil.dominantColor(iconArray[0]);
        changeSelection();
    }

    override function update(elapsed:Float) {
        var okay = controls.ACCEPT;
        var down = controls.UI_DOWN_P;
        var up = controls.UI_UP_P;
        var bacc = controls.BACK;

        if (okay) {
            trace('setting character to ' + characterList[curSelected][0] + '!');
            PlayState.SONG.player1 = characterList[curSelected][0];

            LoadingState.loadAndSwitchState(new PlayState());
        }

        if (bacc) {
            FlxG.sound.play(Paths.sound("cancelMenu"), 0.4);
            MusicBeatState.switchState(new FreeplayState());
        }

        if (down) {
            changeSelection(1);
        }
        if (up) {
            changeSelection(-1);
        }

        super.update(elapsed);
    }
    var colorTween:FlxTween;
    var intendedColor:Int;
    function changeSelection(change:Int = 0, playSound:Bool = true)
        {
            if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
    
            curSelected += change;
    
            if (curSelected < 0)
                curSelected = characterList.length - 1;
            if (curSelected >= characterList.length)
                curSelected = 0;
                
            var newColor:Int = CoolUtil.dominantColor(iconArray[curSelected]);
            if(newColor != intendedColor) {
                if(colorTween != null) {
                    colorTween.cancel();
                }
                intendedColor = newColor;
                colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
                    onComplete: function(twn:FlxTween) {
                        colorTween = null;
                    }
                });
            }
    
            // selector.y = (70 * curSelected) + 30;
    
            var bullShit:Int = 0;
    
            for (i in 0...iconArray.length)
            {
                iconArray[i].alpha = 0.6;
            }
    
            iconArray[curSelected].alpha = 1;
    
            for (item in grpChars.members)
            {
                item.targetY = bullShit - curSelected;
                bullShit++;
    
                item.alpha = 0.6;
                // item.setGraphicSize(Std.int(item.width * 0.8));
    
                if (item.targetY == 0)
                {
                    item.alpha = 1;
                    // item.setGraphicSize(Std.int(item.width));
                }
            }
        }
}