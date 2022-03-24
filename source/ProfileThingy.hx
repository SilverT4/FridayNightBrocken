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
import randomShit.dumb.FunkyBackground;

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
    //var bg:FunkyBackground;
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
        /*bg = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        bg.color = 0xFF0000FF;
        add(bg); */
        add(new FunkyBackground().setColor(0xFF0000FF, false));
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
    var testProfile:ProfileShit = {
        "profileName": "debugBot",
        "playerBirthday": [
            11,
            18
        ],
        "saveName": "debugSave",
        "comment": "How are you seeing this on the save list?!",
        "profileIcon": "devin"
    }; // fun fact: 11/18 is my birthday - devin503
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
        TitleState.currentProfile = cast testProfile;
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

    // PROFILE SETUP IS NOW GETTING ITS OWN FILE

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