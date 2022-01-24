# Adding your own passwords to the Password State

To add your own passwords to the PasswordState.hx file, you'll have to do the following:

1. In the passwordList array at the top, type `,` followed by a new line. Surround your password in single quotes, like so: `'HahaBalls'`.
2. Add a name for the flag you want to associate with your unlock in the save data to the sussyFlags array. Example: `['unlockedYFMBalls', 'unlockedBfOpponent', 'unlockedYFMBalls']`
3. Initialize **two** FlxText variables: One for when the flag exists in the save data, and one for when it does not exist. Example: ```
var hahaMyBalls:FlxText; // This would be for the flag existing
var ohnoMyBalls:FlxText; // This would be the opposite
```
4. In the new function, add the following lines below the if statement for used passwords to initialize them and avoid compilation errors: ```
hahaMyBalls = new FlxText(0, 26 * (however many flags you already had before this one, plus one), '');
ohnoMyBalls = new FlxText(0, 26 * (however many flags you already had before this one, plus one), '');
```
5. Add lines like the ones below to the checkSus() function in the switch case: ```
            case 'unlockedYFMBalls':
                if (FlxG.save.data.unlockedYFMBalls != null) {
                    trace('flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedYFMBalls);
                    hahaMyBalls.text = 'flag ' + sussyFlags[i] + ' exists, value: ' + FlxG.save.data.unlockedYFMBalls;
                    add(hahaMyBalls);
                } else {
                    trace('flag ' + sussyFlags[i] + ' does not exist. initializing...');
                    FlxG.save.data.unlockedYFMBalls = false;
                    ohnoMyBalls.text = 'flag ' + sussyFlags[i] + ' does not exist, initializing...';
                    add(ohnoMyBalls);
                }
```
6. Add lines like the ones below to the prepMainCreate() function in the timer: ```
                if (hahaMyBalls != null) {
                    hahaMyBalls.destroy();
                }
                if (ohnoMyBalls != null) {
                    ohnoMyBalls.destroy();
                }
```
7. Add a case to the switch statement of beginUnlockShit() for your password. Example using the pre-existing Mini Saber unlock for character: ```
            case 'SuspiciousFool': 
                trace('unlocking mini saber');
                setUnlockedContent(0);
                #if debug
                displayResultMsg(0, 0, ['boyfriend', 'mod character', 'Mini Saber', 'skin', 0, 'minisaber']);
                trace('dry run');
                #else
                displayResultMsg(0, 0, ['boyfriend', 'mod character', 'Mini Saber', 'skin', 0, 'minisaber']);
                unlockCharacter(['', '-opponent'], 'minisaber');
                #end
                miniSaber.shader = null;
                miniSaber.animation.play('hey');
```
Example for a noteskin (Note: The argument for unlockNoteskin **must** match the name of your noteskin): ```
            case 'IsThisJustFantaC':
                trace('unlocking dum notes');
                setUnlockedContent(0, 2, ['mod import', 'noteskin', 'Bosip\'s notes', 'from another mod', 2, 'bosip']);
                unlockNoteskin('sussy');
```
Example for a song (Note: The second argument for unlockSong is optional, you can call the function as is with just the song name): ```
            case 'HahaBalls':
                trace('unlocking my balls ( ͡° ͜ʖ ͡°)');
                setUnlockedContent(0, 1, ['classic internet song', 'custom song', 'My Balls', 'by Your Favorite Martian', 'song', 1, 'my-balls']);
                unlockSong('my-balls', ['-easy', '', '-hard', '-sussy']);
```
8. (Optional, for character unlocks) Add your unlockable character to the screen with the following, replacing youIdiot with whatever you want to name the variable:
    i. At the top of your file: `var youIdiot:FlxSprite;`
    ii. In the trueCreate() function: ```
            youIdiot = new FlxSprite(FlxG.width * 0.69, FlxG.height * 0.4);
            youIdiot.frames = FlxAtlasFrames.fromSparrow('path/to/your/character.png', 'path/to/your/character.xml');
            youIdiot.setGraphicSize(256, 256);
            youIdiot.animation.addByPrefix('actingsus', 'Your Idle Animation here', 24, true);
            youIdiot.animation.addByPrefix('venting', 'Any animation that you want here', 24, false); // if your unlock is a BF character add a HEY or something. you can also leave this line out
            youIdiot.animation.play('actingsus');
            youIdiot.shader = lockedShader.shader;
            add(youIdiot);```
    iii. In the update() function: ```
        if (youIdiot != null) {
            youIdiot.update(elapsed);
            if (youIdiot.animation.curAnim.finished) {
                trace('haha beat my balls');
                youIdiot.playAnim('idle');
            } else if (youIdiot.animation.curAnim == null) {
                youIdiot.playAnim('scared');
            }
        }
        ```

## Testing your new unlock
To test your new unlock, compile a new test build of your game. I'll include an example with me unlocking one of my own characters below:
**Menu demo coming soon**