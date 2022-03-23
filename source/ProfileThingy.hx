package;

import lime.app.Application;
import sys.io.File;
import flixel.input.actions.FlxActionInputDigital.FlxActionInputDigitalMouse;
import flixel.addons.ui.FlxUITooltipManager;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIPopup;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxRandom;
import sys.FileSystem;
import haxe.Json;
import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIBar;
import Paths;
import randomShit.util.CustomRandom;
import DialogueBoxPsych;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUIList;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITooltip;
import randomShit.util.DevinsDateStuff;
import randomShit.helpMe.WindowsUtils;
import randomShit.dumb.FNBUINotificationBar;

using StringTools;

/**profiles are smth i want to work on to give the player multiple saves idk*/
typedef ProfileShit = {
    var profileName:String;
    var playerBirthday:Array<Dynamic>; // BECAUSE APPARENTLY THAT'S THE ONLY WAY TO ALLOW STRINGS *OR* INTS.
    var saveName:String;
    var comment:String;
    var profileIcon:String;
}

/**This will be shown at launch ig*/
class PrelaunchProfileState extends FlxState {
    var bg:FlxSprite;
    var itemDescBg:FlxSprite;
    var itemDesc:FlxText;
    var saveListBox:FlxUITabMenu;
    var saveList:FlxUIList;
    var saveNameInputPlaceholder:FlxUIInputText;
    var testvar:String;
    var bsOutputPath:String = Sys.getCwd();
    public static var batteryPath:String;

    public function new() {
        super();
        if (!FlxG.mouse.visible) FlxG.mouse.visible = true;
        if (FlxG.mouse.useSystemCursor) FlxG.mouse.useSystemCursor = false;
        /*#if (debug && windows)
        var fartsauce = bsOutputPath.split('/');
        batteryPath = fartsauce[0];
        trace(batteryPath);
        Sys.command('wmic', ["/output:" + Sys.getCwd() + "\\battery.txt", "path win32_battery", "get estimatedchargeremaining"]);
        trace(Sys.getCwd());
        //testvar = sys.io.File.getContent('battery.txt');
        //trace(testvar);
        #end */
        DevinsDateStuff.getHour();
        //trace(Sys.environment());
    }

    override function create() {
        FlxG.cameras.fade(FlxColor.BLACK, 1, true, function() {
            trace('pp');
        });
        if (FlxG.sound.music == null) {
            FlxG.sound.play(Paths.sound('DSBoot'));
                FlxG.sound.playMusic(Paths.music('DSClock'), 1);
        }
        bg = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.color = 0xFF0000FF;
        add(bg);
        itemDescBg = new FlxSprite(0).makeGraphic(FlxG.width, 26, FlxColor.fromRGB(0, 0, 0, 128));
        itemDescBg.y = FlxG.height - 26;
        add(itemDescBg);
        itemDesc = new FlxText(0, itemDescBg.y + 4, FlxG.width, 'Select a save above. If you do not see yours, click Create.', 24);
        itemDesc.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(itemDesc);
        var tabs = [
            {name: 'Saves', label: 'Saves'}
        ];
        saveListBox = new FlxUITabMenu(null, tabs, true);
        saveListBox.resize(Std.int(FlxG.width), Std.int(FlxG.height - 26));
        add(saveListBox);
        generateBasicControls();
    }
    var loadButton:FlxButton;
    var eraseButton:FlxButton;
    var createButton:FlxButton;
    function generateBasicControls() {
        trace('sus');
        var tab_group = new FlxUI(null, saveListBox);
        tab_group.name = 'Saves';
        loadButton = new FlxButton(FlxG.width - 128, 20, 'Load this save', loadSave);
        createButton = new FlxButton(loadButton.x, loadButton.y + 50, 'Create new save', createSave);
        eraseButton = new FlxButton(createButton.x, createButton.y + 50, 'Erase this save', eraseSave);
        eraseButton.color = FlxColor.RED;
        eraseButton.label.color = FlxColor.WHITE;
        saveList = new FlxUIList(10, 20, null, FlxG.width - 130, FlxG.height - 30, "<X> more saves...", null, 2);
        saveNameInputPlaceholder = new FlxUIInputText(loadButton.x - 210, loadButton.y, 200, 'dum', 8);
        
        var shitButton = new FlxButton(FlxG.width - 128, FlxG.height - 69, 'DEBUG SKIP', function() {
            openSubState(new DebugProfileSubstate());
        });
        shitButton.color = FlxColor.BLUE;
        #if !debug
        shitButton.label.text = 'Strange Button';
        #end
        shitButton.label.color = FlxColor.WHITE;
        tab_group.add(new FlxText(15, 30, (FlxG.width - 18 - 210 - 210), getSaveList(), 8).setFormat("VCR OSD Mono", 16));
        tab_group.add(shitButton);
        tab_group.add(new FlxText(saveNameInputPlaceholder.x, saveNameInputPlaceholder.y - 18, 0, '(PLACEHOLDER) Input a save name...', 8).setFormat("VCR OSD Mono", 8));
        tab_group.add(saveNameInputPlaceholder);
        tab_group.add(loadButton);
        tab_group.add(createButton);
        tab_group.add(eraseButton);
        saveListBox.addGroup(tab_group);
    }

    function getSaveList() {
        if (FileSystem.exists('profiles')) {
            var bussy = FileSystem.readDirectory('profiles');
            var withoutExt:Array<String> = []; // so i can have an actual array to push to
            for (egg in bussy) {
                withoutExt.push(egg.replace('.json', ''));
            }
            return "Save list:\n" + withoutExt.join('\n');
        } else {
            return "No saves found. Click the Create button to set up a save.";
        }
    }

    inline function loadSave() {
        // FlxG.switchState(new LoadDEFromProfiles()); don't need this anymore!!
        TitleState.currentProfile = getProfileData(saveNameInputPlaceholder.text);
        FlxG.sound.play(Paths.sound('menuConfirm'));
        FlxG.sound.music.stop();
        FlxG.sound.music = null;
        new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(new TitleState());
				});
			}); // COPIED FROM DEBUG SUBSTATE
    }

    inline function getProfileData(name:String) {
        trace('gotta check existence first!');
        if (FileSystem.exists('profiles/' + name + '.json')) return cast Json.parse(File.getContent('profiles/' + name + '.json'));
        else {
            doProfileErrorShit(-1);
            return placeholderProfile;
        }
    }
    function doProfileErrorShit(ErrorCode:Int) {
        switch (ErrorCode) {
            case -1:
                Application.current.window.alert('Profile data for ' + saveNameInputPlaceholder.text + ' does not exist.\nPlease check spelling and capitalisation. If this issue persists,\ntry re-creating your profile.');
        }
    }
    static inline function createSave() {
        FlxG.sound.play(Paths.sound('menuConfirm'));
        new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(new ProfileSetupWizard());
				});
			});
    }
    static inline function eraseSave() {
        trace('test');
    }
    override function update(elapsed:Float) {
        if (itemDesc != null) {
            itemDesc.update(elapsed);
        }
        if (saveListBox != null) {
            saveListBox.update(elapsed);
        }
    }
    static var placeholderProfile = {
        "profileName": "placeholderprofile",
        "playerBirthday": randomShit.util.DevinsDateStuff.getTodaysDate(),
        "saveName": "profileNotFound",
        "comment": "How are you seeing this on the save list?!",
        "profileIcon": "devin"
    };
}

/****DEBUG**
    Debug options. Includes a "test" profile.*/
class DebugProfileSubstate extends FlxSubState {
    var testProfile:String = '{
        "profileName": "debugBot",
        "playerBirthday": [
            11,
            18
        ],
        "saveName": "debugSave",
        "comment": "How are you seeing this on the save list?!",
        "profileIcon": "devin"
    }'; // fun fact: 11/18 is my birthday - devin503
    var useTestProfile:FlxButton;
    var skipSaves:FlxButton;
    var backButton:FlxButton;
    var clock:FlxText;
    var battery:FlxText;
    var bussy:Date;
    var shart:String;
    var cum:FlxUITooltip;
    var wmicOut:String = '';
    var dumbthing:String;
    var sex:FlxUITooltipManager;
    var penisTest:Bool = false;
    var penis:FNBUINotificationBar;
    /**GIRL YES!!

    This is just an array of the weirdest GIRL YES!! comments I've ever seen on TikTok or Discord.
    
    Also has some of the cursed sex comments I've seen on TikTok.*/
    public static var girlYes:Array<String> = [
        'GIRL YES!!! i love smelling my cousins dirty underwear, sometimes when im lucky they even have a stain of cvm on them, they turn me on',
        'GIRLLL YESSS!!! I LOVE FINDING SPIDER EGGS AND PUTTING THEM IN MY VGYNA!! WHEN THEY HATCH THEY ALWAYS SCRATCH THE PLACES I CANT REACH!!',
        'GIRL YES !!!! I LOVE MIXING MY CVM WITH MY SISTERS PERIOD BLOOD!!!! LOOKS LIKE A STRAWBERRY SMOOTHIE!!',
        'GIRL YES!! I LOVE IT WHEN I FART AND IT SMELLS SO BAD THAT FLOWERS WILT AND EVERYONE AROUND ME ALMOST DIES!',
        'GIRL YESS!!!! MY UNCLE WAS CLIPPING HIS TOENAILS AND HE LEFT THEM ALL ON THE FLOOR AND I SUCKED THEM UP THRU MY PÜŠŠŸ LIKE A VACUUM',
        'GIRLL YESSS MY STEPBRO CAME IN THE BATHROOM AND HE STARTED “HELPING” ME WITH THE LAUNDRY I CAN STILL FEEL HIS WHITE DETERGENT ON ME',
        'GIRL YES!! YOU\'RE INVITED TO JIAFEI\'S HAUNTED CVM HOUSE! BRING YOUR FAMILY, YOUR OCS, HELL, JUST BRING THE ENTIRE WORLD!!',
        'GIRL YESS!!!!! I LOVE IT WHEN MR KRABS SHOVES HIS SECRET FORMULA IN MY SAFE WHERE HE CAN RELEASE THE SECRET RECIPE',
        'Girl yes!! My stepdad takes the huggest sh!ts and before he flushed I go and drink his diarrhea!!!',
        'Girl YESSS!!! I LOVE USING MY GRANDMAS USED PADS AS A FACE MASK IN CLASS!! EVERYONE WANTS A SNIFF!',
        'GIRL YES! I love smelling your dad\'s used pads, they smell like heaven. I look forward to drinking the leftover period blood every month!',
        'Girl YESS! When I saw a huge boner on my teacher I will go secretly take his boxers and smell it like a perfume!',
        'GIRL YESSS!!! The lunch lady kidnapped me and used a scooper and shove it on me and I cvmmed and she used my cvm for a new milk for lunch!!',
        'GIRL YESS I LIKE WHEN GRANDPA SUCK ON MY BEEF PATTY AND THEN THE DUST GETS IN AND I LICK IT UP',
        'GIRL YES!! MY 4 GAY UNCLES CVMED OVER TO MY HAUNTED HOUSE AND HAD SVX!!! I WASNT IN IT BUT I WATCHED AND THEY BECAME FAMOUS CORNSTARS!',
        'Walmart starts whimpering as target goes in Walmart quietly moaning so the others don’t hear as target goes deeper and Walmart moans very loud.',
        'Girl YES! I love it when my math teacher jerks off in class and then all the hornknee students go to lick up his cvm -- I always get the most!',
        'Wendy begins screaming as McDonalds shoves it in. Instead of saying babababa. She began to say ahahahah. And as it says I’m lovin it shes also love it',
        'as Russia pounded Ukraine, Ukraine smiled and said "I never knew you were this good :weary:"',
        '*target moaned as Walmart thrusted into target* Walmart: shhhhhh we can’t let Amazon hear or you will be in bigger trouble~~~~… *as target cried*',
        'Sonic held Mario as he continuously moaned. Sonic grinned and whispered “my sweet Mario..”',
        'YouTube grunted pounding into tiktok, TikTok smiled “wow YouTube W for you”',
        'that’s not how you do it! “ dominos said as Pizza Hut thrusted into her. “ Pizza Hut stop~! “ dominos moaned helplessly',
        'Ohhh gooooon “sticks squidwards nose out” that power is so strong and good i wanna crush you “ gon look at hisoka up and down and runs” ohhhhhhh gon',
        '"s-shadow please be gentle~" said the smaller blue hedgehog to the bigger alpha male dominate "heh, well see ~" said the bigger black hedgehog smirkin',
        'Amazon starts going inside ebay very slowly but surely,Amazon groans and eBay moans,Amazon starts going crazy and eBay twerks Amazon creams everywhere',
        'KFC puts it in deeper into McDonald\'s while mdonalds moans softly, KFC goes harder then McDonald\'s moans loudly and starts cvmming in kfc',
        '"Ah~" said roblox as fortnite thrusts deeper "want to go slower?~" said fortnite "n-no d-daddy" says roblox as he squirts',
        '*Roblox moans* “AHH~ MINECRAFT~ HARDER~ *minecraft goes harder* “Is that better baby?😏” “OH YES~ DADDY~ OH~ MMMM~ THIS FEELS SO GOOD~” “Roblox moans”',
        'ahh!~ It’s too big!~ said pillow chan as blanket san put his big juicy long blanketussy in him. Shh~ Mattress san will hear us!~ Blanket san told her.',
        'mcdonald’s moans “a-ahh!~” burger king shushes him “sshh~.. dont want the others too hear~” burger king goes deeper, mcdonald’s moans loudly.'
    ];
    #if debug
    public function new() {
        super();
        trace(girlYes.length + ' girl yes comments. what am i doing in my life.');
        for (i in 0...girlYes.length) trace('comment ' + i + ' of ' + girlYes.length + ':\n' + girlYes[i]);
        useTestProfile = new FlxButton(0, 0, 'Test Profile', useTest);
        skipSaves = new FlxButton(0, 0, 'Skip Saves', skipSaveLoad);
        shart = Std.string(Date.now());
        clock = new FlxText(0, 0, FlxG.width, DevinsDateStuff.dumbClock(), 16);
        clock.scrollFactor.set();
        clock.setFormat("Nintendo DS BIOS Regular", 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        useTestProfile.screenCenter();
        useTestProfile.x -= 150;
        skipSaves.screenCenter();
        skipSaves.x += 150;
        backButton = new FlxButton(FlxG.width - 100, FlxG.height - 24, 'Back', function() {
            close();
        });
        #if windows
        if (!AntivirusAvoidanceState.DISABLE_SUS_FUNC) {
        var bullshit:String = Sys.getCwd();
        var doodoo = bullshit.split('/');
        /* trace("/output:" + doodoo[0] + "\\battery.txt path win32_battery get estimatedchargeremaining");
        var benis:Array<String> = ["/output:" + doodoo[0] + "\\battery.txt path win32_battery get estimatedchargeremaining"];
        trace(benis);
        Sys.command('wmic', benis);
        dumbthing = sys.io.File.getContent('battery.txt');
        var ass = dumbthing.split('\r\n');
        wmicOut = ass[1]; */
        trace(WindowsUtils.getCurrentWinNTVersion());
        wmicOut = WindowsUtils.getRemainingBattery();
        sex = new FlxUITooltipManager();
        battery = new FlxText(0, 0, FlxG.width, wmicOut + "%", 24);
        battery.setFormat("Nintendo DS Bios Regular", 24, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        sex.add(battery, {title: "Battery: " + wmicOut + "%", body: "This is a battery thing. If your battery is below 20%, you may want to charge."});
        }
        #end
        penis = new FNBUINotificationBar(girlYes[CustomRandom.int(0, girlYes.length)], 28);
        new FlxTimer().start(3, function(tmr:FlxTimer) {
            penisTest = true;
            FlxG.sound.play(Paths.sound('information'));
        });

        add(new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 0, 128, 128)));
        add(useTestProfile);
        add(clock);
        #if windows
        if (!AntivirusAvoidanceState.DISABLE_SUS_FUNC) add(battery);
        #end
        add(penis);
        add(penis.msgDisplay);
        add(skipSaves);
        add(backButton);
        //FlxG.sound.playMusic('mods/music/dooDooFeces.ogg'); no more doo doo feces
    }

    override function update(elapsed:Float) {
        if (useTestProfile != null) {
            useTestProfile.update(elapsed);
        }
        if (skipSaves != null) {
            skipSaves.update(elapsed);
        }
        if (backButton != null) {
            backButton.update(elapsed);
        }
        if (clock != null) {
            clock.update(elapsed);
            shart = Std.string(Date.now());
            var shit = shart.split(' ');
            clock.text = shit[1];
        }
        if (penisTest) {
            penisTest = false;
            if (penis != null) {
                penis.show(15);
            }
        }
        if (penis != null) {
            penis.update(elapsed);
        }
    }

    function useTest() {
        TitleState.currentProfile = cast Json.parse(testProfile);
        FlxG.sound.play(Paths.sound('menuConfirm'));
        FlxG.sound.music.stop();
        FlxG.sound.music = null;
        new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(new TitleState());
				});
			});
    }

    function skipSaveLoad() {
        FlxG.sound.play(Paths.sound('confirmMenu'));
            new FlxTimer().start(0.7, function(tmr:FlxTimer)
                {
                    FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
                    {
                        FlxG.sound.music.stop();
                        FlxG.sound.music = null;
                        FlxG.switchState(new TitleState());
                    });
                });
    }
    #else
    public function new() {
        super();
        FlxG.switchState(new shitpost.YouThoughtYouAte());
    }
    #end
}
/**setup wizard thingy*/
class ProfileSetupWizard extends FlxState {
    var bg:FlxSprite;
    var dumb:DialogueFile;
    var dialogueCount:Int = 0;
    var psychDialogue:DialogueBoxPsych;
    var inDialogue:Bool = false;
    var setupBox:FlxUITabMenu;
    var defaults:String = '{
        "profileName": "Default",
        "playerBirthday": [
            1,
            1
        ],
        "saveName": "default",
        "comment": "amogus",
        "profileIcon": "bf"
    }';
    var basicBitch:ProfileShit;
    var someFunnyDefaultComments:Array<String> = [
        'Insert funny comment here',
        'I like the snow',
        'Dumb boyfriend steal your comment? Buy this sexy cum product to cure!',
        'All your notes are belong to me',
        'Never gonna give you up...',
        'You have been bread loafed. Share this within the next 69 seconds to bread loaf someone else'
    ];

    public function new() {
        super();
        trace('smack my ass like a drum');
        PlayerSettings.init();
        basicBitch = cast Json.parse(defaults);
    }

    override function create() {
        bg = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.scrollFactor.set();
        bg.color = 0xFFAACCFF;
        add(bg);
        FlxG.sound.playMusic(Paths.music('wiiPlay_Menu'));
        inDialogue = true;
        dumb = cast Json.parse(Paths.snowdriftChatter('profileIntro'));
        startDialogue(dumb);
    }
    override function update(elapsed:Float) {
        if (psychDialogue != null) {
            psychDialogue.update(elapsed);
        }
        if (setupBox != null) {
            setupBox.update(elapsed);
        }
    }
    public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
        {
            // TO DO: Make this more flexible, maybe?
            if(psychDialogue != null) return;
    
            if(dialogueFile.dialogue.length > 0) {
                // inCutscene = true;
                CoolUtil.precacheSound('dialogue', 'shared');
                CoolUtil.precacheSound('dialogueClose', 'shared');
                psychDialogue = new DialogueBoxPsych(dialogueFile);
                psychDialogue.scrollFactor.set();
                    psychDialogue.finishThing = function() {
                        psychDialogue = null;
                        if (setupBox == null) {
                            makeTheBox();
                        }
                        if (houston) {
                            showConflictUI();
                        }
                    }
                psychDialogue.nextDialogueThing = startNextDialogue;
                psychDialogue.skipDialogueThing = skipDialogue;
                // psychDialogue.cameras = [camHUD];
                add(psychDialogue);
            } else {
                FlxG.log.warn('Your dialogue file is badly formatted!');
                //MusicBeatState.switchState(new options.OptionsState());
            }
        }
        //var dialogueCount:Int = 0;
        function startNextDialogue() {
            dialogueCount++;
        }

        function skipDialogue() {
            //callOnLuas('onSkipDialogue', [dialogueCount]);
            trace('ass');
        }

        function makeTheBox() {
            var tabs = [{name: 'SHIT', label: 'Setup'}];
            setupBox = new FlxUITabMenu(null, tabs, true);
            setupBox.resize(250, 300);
            setupBox.screenCenter();
            add(setupBox);
            makeSetupUI();
        }
        var conflictBox:FlxUIPopup;
        var conflictedName:String = '';
        function showConflictUI() {
            trace('ass');
            conflictBox = new FlxUIPopup();
            conflictBox.quickSetup('Profile conflict', 'A profile with the name of ' + conflictedName + ' already exists on this PC. If you continue, ALL data in the existing profile will be overwritten.\nDo you want to continue?', ['Continue', 'Cancel']);
            add(conflictBox);
        }
        var dataToSave:ProfileShit;
        var randomNumber:Int;
        var useNowChecker:FlxUICheckBox;
        var useRightAway:Bool = false;
        function makeSetupUI() {
            var tab_group = new FlxUI(null, setupBox);
            tab_group.name = 'SHIT';

            var profileNameInputter:FlxUIInputText = new FlxUIInputText(10, 50, 150, basicBitch.profileName, 8);

            var bdayMonthInputter:FlxUIInputText = new FlxUIInputText(10, profileNameInputter.y + 30, 50, Std.string(basicBitch.playerBirthday[0]), 8);
            var bdayDateInputter:FlxUIInputText = new FlxUIInputText(bdayMonthInputter.x + 100, bdayMonthInputter.y, 50, Std.string(basicBitch.playerBirthday[1]), 8);

            var saveNameInputter:FlxUIInputText = new FlxUIInputText(10, bdayDateInputter.y + 30, 150, basicBitch.saveName, 8);

            var commentInputter:FlxUIInputText = new FlxUIInputText(10, saveNameInputter.y + 30, 150, basicBitch.comment, 8);
            var profileIconInputter:FlxUIInputText = new FlxUIInputText(10, commentInputter.y + 30, 150, basicBitch.profileIcon, 8);
            var saveButton:FlxButton = new FlxButton(commentInputter.getGraphicMidpoint().x, commentInputter.y + 100, 'Done', function() {
                randomNumber = CustomRandom.int(0, someFunnyDefaultComments.length - 1);
                if (commentInputter.text.length >= 1) {
                    dataToSave = {
                    "profileName": profileNameInputter.text,
                    "playerBirthday":[ 
                        bdayMonthInputter.text,
                        bdayDateInputter.text
                    ],
                    "saveName": saveNameInputter.text,
                    "comment": commentInputter.text,
                    "profileIcon": profileIconInputter.text
                };
            } else {
                dataToSave = {
                    "profileName": profileNameInputter.text,
                    "playerBirthday":[ 
                        bdayMonthInputter.text,
                        bdayDateInputter.text
                    ],
                    "saveName": saveNameInputter.text,
                    "comment": someFunnyDefaultComments[randomNumber],
                    "profileIcon": profileIconInputter.text
                };
            }
                trace(dataToSave);
                saveProfile(dataToSave);
            });
            useNowChecker = new FlxUICheckBox(saveButton.x, saveButton.y - 30, null, null, 'Use right away?', 100, null, function() {
                useRightAway = !useRightAway;
                trace('Using after save: ' + useRightAway);
            });
            useNowChecker.checked = useRightAway;
            tab_group.add(useNowChecker);

            tab_group.add(new FlxText(10, profileNameInputter.y - 18, 0, 'Profile name', 8));
            tab_group.add(new FlxText(10, bdayMonthInputter.y - 18, 0, 'Birthday', 8));
            tab_group.add(new FlxText(10, saveNameInputter.y - 18, 0, 'Save name', 8));
            tab_group.add(new FlxText(10, commentInputter.y - 18, 0, 'Comment', 8));
            tab_group.add(new FlxText(10, profileIconInputter.y - 18, 0, 'Profile icon', 8));
            tab_group.add(profileNameInputter);
            tab_group.add(bdayMonthInputter);
            tab_group.add(bdayDateInputter);
            tab_group.add(saveNameInputter);
            tab_group.add(commentInputter);
            tab_group.add(profileIconInputter);
            tab_group.add(saveButton);
            setupBox.addGroup(tab_group);
        }
        var houston:Bool = false;
        var newThing:FlxSave;
        var ignoringConflict:Bool = false;
        function saveProfile(profile:ProfileShit) {
            var hhhhhh = profile;
            if (FileSystem.exists('profiles/' + hhhhhh.profileName + '.json') && !ignoringConflict) {
                trace('MUST ASK IF WE WILL OVERWRITE!');
                houston = true; //houston, we've got a problem
                conflictedName = hhhhhh.profileName;
                dumb = cast Json.parse(Paths.snowdriftChatter('profileConflict'));
                startDialogue(dumb);
            } else {
                sys.io.File.write('profiles/' + hhhhhh.profileName + '.json');
                sys.io.File.saveContent('profiles/' + hhhhhh.profileName + '.json', Json.stringify(hhhhhh, "\t"));
                newThing = new FlxSave();
                newThing.bind(hhhhhh.saveName, 'fridayNightBrocken');
                trace(newThing);
                if (ignoringConflict) {
                    newThing.erase();
                    newThing.bind(hhhhhh.saveName, 'fridayNightBrocken');
                }
                newThing.data.profileName = hhhhhh.profileName;
                newThing.data.playerBirthday = hhhhhh.playerBirthday;
                newThing.data.saveName = hhhhhh.saveName;
                newThing.data.comment = hhhhhh.comment;
                trace(newThing.data);
                if (!useRightAway) {
                    new FlxTimer().start(0.7, function(tmr:FlxTimer)
                    {
                        FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
                        {
                            FlxG.switchState(new PrelaunchProfileState());
                        });
                    });
                } else {
                    new FlxTimer().start(0.7, function(tmr:FlxTimer) {
                        FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {
                            FlxG.save.bind(hhhhhh.profileName, 'fridayNightBrocken');
                            FlxG.switchState(new TitleState());
                        });
                    });
                }
            }
        }
}

class LoadDEFromProfiles extends MusicBeatState {
    public function new() {
        super();
        PlayerSettings.init();
        ClientPrefs.loadPrefs();
    }

    override function create() {
        LoadingState.loadAndSwitchState(new editors.DialogueEditorState());
    }
}