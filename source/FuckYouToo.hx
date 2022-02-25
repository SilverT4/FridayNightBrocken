package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FuckYouToo extends MusicBeatSubstate {
    var fuckYouText:FlxText;
    var bamber:FlxSprite;

    public function new() {
        super();
        FlxG.sound.play(Paths.sound('daFunniWell'));
        var fu:FlxSprite = new FlxSprite(0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(255, 128, 255, 128));
        fu.screenCenter();
        add(fu);
        fuckYouText = new FlxText(0, 0, FlxG.width, 'HAHAHAHAHAHAHA\n\nFUCK YOU TOO, BUDDY!\n\nTell ya what. Since you think you\'re SOOOOO funny...\n\nLet\'s see how you handle this!');
        fuckYouText.setFormat(Paths.font('vcr.ttf'), 48, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        fuckYouText.screenCenter();
        add(fuckYouText);
        bamber = new FlxSprite(fuckYouText.x, fuckYouText.y);
        bamber.frames = Paths.getSparrowAtlas('characters/bamb', 'shared');
        bamber.animation.addByPrefix('fuckYou', 'BF HEY', 24);
        bamber.animation.play('fuckYou');
        add(bamber);
        PlayState.dunFuckedUpNow = true;
        PlayState.SONG = Song.loadFromJson('cheating', 'cheating');
        PlayState.SONG.player2 = 'bambi-old';
        PlayState.SONG.player3 = 'nogflol';
        new FlxTimer().start(3, function pussy(tmr:FlxTimer) {
            MusicBeatState.switchState(new SelectChara());
        });
    }

    override function update(elapsed:Float) {
        if (bamber != null) {
            bamber.update(elapsed);
        }
    }
}